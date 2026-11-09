#!/usr/bin/env bash
# Shared functions for the check.sh scripts in the scenarios.
# They need bash, curl, mvn and docker with Compose v2 (on Windows: Git Bash + Docker Desktop).

# Git Bash on Windows: do not turn arguments starting with / into Windows paths
export MSYS_NO_PATHCONV=1
APP=${APP:-http://localhost:8080}
LIB_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
SCEN_DIR=$(cd "$(dirname "$0")" && pwd)
SCEN_NAME=$(basename "$SCEN_DIR")
PROJECT="kurs-docker-${SCEN_NAME%%-*}"
PASS=0
FAIL=0
BODY_FILE=$(mktemp)
OUT_FILE=$(mktemp)
trap 'rm -f "$BODY_FILE" "$OUT_FILE"' EXIT

# All docker compose commands run in the scenario directory
cd "$SCEN_DIR" || exit 1

ok()  { echo "  [OK]   $1"; PASS=$((PASS+1)); }
bad() { echo "  [FAIL] $1"; FAIL=$((FAIL+1)); }
info() { echo "  ...    $1"; }
indent() { sed 's/^/         /'; }

require_docker() {
  if ! docker info > /dev/null 2>&1; then
    echo "  [FAIL] Docker nie odpowiada. Uruchom Docker Desktop i spróbuj ponownie."
    exit 1
  fi
}

# Containers of other scenarios take port 8080, so we stop them.
stop_other_scenarios() {
  local p ids
  for p in $(docker ps --format '{{.Label "com.docker.compose.project"}}' | sort -u | grep '^kurs-docker-'); do
    [ "$p" = "$PROJECT" ] && continue
    ids=$(docker ps -q --filter "label=com.docker.compose.project=$p")
    if [ -n "$ids" ]; then
      info "zatrzymuję kontenery innego scenariusza ($p)"
      docker stop $ids > /dev/null
    fi
  done
}

# Builds the application jar on the host (target/shop.jar), as described in ZADANIE.md.
build_jar() {
  info "mvn package (budowanie target/shop.jar)"
  if ! mvn -q -B package -DskipTests > "$OUT_FILE" 2>&1; then
    bad "mvn package nie powiódł się:"
    tail -n 20 "$OUT_FILE" | indent
    summary
  fi
}

# Starts the scenario from scratch: down -v (also deletes volumes), then up --build.
compose_up() {
  info "docker compose down -v, potem docker compose up --build -d"
  docker compose down -v --remove-orphans > /dev/null 2>&1
  if docker compose up --build -d > "$OUT_FILE" 2>&1; then
    ok "docker compose up --build -d"
  else
    bad "docker compose up --build -d zakończył się błędem. Ostatnie linie:"
    grep -v '^ *$' "$OUT_FILE" | tail -n 15 | indent
    summary
  fi
}

# Container id of the service (also a stopped one).
cid() { docker compose ps -a -q "$1" 2>/dev/null | head -n 1; }

# docker inspect with a format for the service container: insp app '{{.State.ExitCode}}'
insp() { local id; id=$(cid "$1"); [ -n "$id" ] && docker inspect -f "$2" "$id" 2>/dev/null | tr -d '\r'; }

# Waits until the application answers at $APP (or at least prints "Started" in the logs).
# Stops right away when the container has exited or is restarting.
wait_app() {
  local timeout=${1:-90} svc=${2:-app} i code state restarts started="" answered=""
  info "czekam na aplikację (max $timeout s)"
  for ((i = 0; i < timeout; i++)); do
    state=$(insp "$svc" '{{.State.Status}}')
    restarts=$(insp "$svc" '{{.RestartCount}}')
    if [ "$state" = "exited" ] || [ "$state" = "dead" ] || [ "${restarts:-0}" -gt 0 ]; then
      if [ "${restarts:-0}" -gt 0 ]; then
        bad "Kontener $svc restartuje się (restartów: $restarts, stan: $(docker compose ps -a --format '{{.Status}}' "$svc")). Z logów:"
      else
        bad "Kontener $svc nie działa: $(docker compose ps -a --format '{{.Status}}' "$svc"). Z logów:"
      fi
      log_hint "$svc"
      summary
    fi
    # The application answers: watch it for 3 more seconds in case it dies right after startup.
    code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 2 "$APP/actuator/health")
    if [ "$code" != "000" ] && [ "$code" != "502" ]; then
      [ -z "$answered" ] && answered=$i
      (( i - answered >= 3 )) && return 0
    fi
    # Spring printed "Started" but the application does not answer: give it 15 more seconds
    # (for an error right after startup, or because it is simply unreachable).
    if [ -z "$started" ] && (( i % 3 == 2 )) && docker compose logs "$svc" 2>/dev/null | grep -q "Started ShopApplication"; then
      started=$i
    fi
    if [ -n "$started" ] && (( i - started >= 15 )); then return 0; fi
    sleep 1
  done
  bad "Aplikacja nie odpowiada pod $APP po $timeout s (kontener $svc: $(docker compose ps -a --format '{{.Status}}' "$svc"))"
  summary
}

# The most important lines from the service logs: error causes, or the last lines if there are none.
log_hint() {
  local lines
  lines=$(docker compose logs --no-log-prefix "$1" 2>&1 | grep -E '^Caused by|^Error|^Exception|ERROR|^[a-zA-Z.]+(Exception|Error):' | tail -n 6)
  [ -z "$lines" ] && lines=$(docker compose logs --no-log-prefix --tail 8 "$1" 2>&1)
  [ -z "$lines" ] && lines="(logi są puste)"
  echo "$lines" | cut -c1-240 | indent
  echo "         Całość: docker compose logs $1 (w katalogu scenariusza)"
}

# Sends a request; sets CODE, BODY and HEADERS. Arguments as for curl.
call() {
  local hdr
  hdr=$(mktemp)
  : > "$BODY_FILE"
  CODE=$(curl -s -o "$BODY_FILE" -D "$hdr" -w '%{http_code}' --max-time "${MAX_TIME:-15}" "$@")
  BODY=$(cat "$BODY_FILE")
  HEADERS=$(tr -d '\r' < "$hdr")
  rm -f "$hdr"
}

# expect_status "description" 200 <curl arguments>
expect_status() {
  local desc=$1 expected=$2; shift 2
  call "$@"
  if [ "$CODE" = "$expected" ]; then ok "$desc (HTTP $CODE)"; else bad "$desc: oczekiwano HTTP $expected, jest HTTP $CODE. Body: ${BODY:0:300}"; fi
}

# expect_body "description" 'fragment' <curl arguments>  (also checks for HTTP 2xx)
expect_body() {
  local desc=$1 fragment=$2; shift 2
  call "$@"
  if [[ "$CODE" == 2* ]] && grep -qF -- "$fragment" "$BODY_FILE"; then
    ok "$desc"
  else
    bad "$desc: oczekiwano HTTP 2xx i fragmentu $fragment, jest HTTP $CODE. Body: ${BODY:0:300}"
  fi
}

# expect_eq "description" "value" "expected"
expect_eq() {
  if [ "$2" = "$3" ]; then ok "$1"; else bad "$1: jest '${2:0:200}', oczekiwano '$3'"; fi
}

# expect_logs "description" service 'fragment'
expect_logs() {
  if docker compose logs --no-log-prefix "$2" 2>/dev/null | grep -qF -- "$3"; then
    ok "$1"
  else
    bad "$1: w 'docker compose logs $2' nie ma: $3"
  fi
}

# Value of a numeric JSON field, e.g. json_num maxHeapMb
json_num() { echo "$BODY" | grep -o "\"$1\":[0-9]*" | head -n 1 | cut -d: -f2; }

summary() {
  echo
  if [ "$FAIL" = 0 ]; then
    echo "WYNIK: wszystkie sprawdzenia przeszły ($PASS). Scenariusz naprawiony!"
  else
    echo "WYNIK: $FAIL nie przeszło, $PASS przeszło. Szukaj dalej."
  fi
  echo "(Kontenery scenariusza zostały uruchomione. Zatrzymasz je: docker compose down -v w katalogu scenariusza albo ./scripts/stop-all.sh)"
  [ "$FAIL" = 0 ]
  exit $?
}
