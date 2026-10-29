#!/usr/bin/env bash
# Wspólne funkcje dla skryptów check.sh w scenariuszach.
# Wymagają bash, curl, mvn i dockera z Compose v2 (na Windows: Git Bash + Docker Desktop).

# Git Bash na Windows: nie zamieniaj argumentów zaczynających się od / na ścieżki Windows
export MSYS_NO_PATHCONV=1
curl() {
  env -u MSYS_NO_PATHCONV curl "$@"
}
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

# Wszystkie polecenia docker compose działają w katalogu scenariusza
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

# Kontenery innych scenariuszy zajmują port 8080, więc je zatrzymujemy.
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

# Buduje jar aplikacji na hoście (target/sklep.jar), tak jak opisuje ZADANIE.md.
build_jar() {
  info "mvn package (budowanie target/sklep.jar)"
    if ! env -u MSYS_NO_PATHCONV mvn -q -B package -DskipTests > "$OUT_FILE" 2>&1; then
    bad "mvn package nie powiódł się:"
    tail -n 20 "$OUT_FILE" | indent
    summary
  fi
}

# Uruchamia scenariusz od zera: down -v (kasuje też wolumeny), potem up --build.
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

# Id kontenera serwisu (także zatrzymanego).
cid() { docker compose ps -a -q "$1" 2>/dev/null | head -n 1; }

# docker inspect z formatem dla kontenera serwisu: insp app '{{.State.ExitCode}}'
insp() { local id; id=$(cid "$1"); [ -n "$id" ] && docker inspect -f "$2" "$id" 2>/dev/null | tr -d '\r'; }

# Czeka, aż aplikacja odpowie pod $APP (albo przynajmniej wypisze "Started" w logach).
# Przerywa od razu, gdy kontener się zakończył lub restartuje.
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
    # Aplikacja odpowiada: jeszcze 3 s obserwacji, czy nie padnie tuż po starcie.
    code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 2 "$APP/actuator/health")
    if [ "$code" != "000" ] && [ "$code" != "502" ]; then
      [ -z "$answered" ] && answered=$i
      (( i - answered >= 3 )) && return 0
    fi
    # Spring wypisał "Started", a aplikacja nie odpowiada: dajemy jej jeszcze 15 s
    # (na błąd tuż po starcie albo na to, że po prostu jest nieosiągalna).
    if [ -z "$started" ] && (( i % 3 == 2 )) && docker compose logs "$svc" 2>/dev/null | grep -q "Started SklepApplication"; then
      started=$i
    fi
    if [ -n "$started" ] && (( i - started >= 15 )); then return 0; fi
    sleep 1
  done
  bad "Aplikacja nie odpowiada pod $APP po $timeout s (kontener $svc: $(docker compose ps -a --format '{{.Status}}' "$svc"))"
  summary
}

# Najważniejsze linie z logów serwisu: przyczyny błędów, a gdy ich brak, ostatnie linie.
log_hint() {
  local lines
  lines=$(docker compose logs --no-log-prefix "$1" 2>&1 | grep -E '^Caused by|^Error|^Exception|ERROR|^[a-zA-Z.]+(Exception|Error):' | tail -n 6)
  [ -z "$lines" ] && lines=$(docker compose logs --no-log-prefix --tail 8 "$1" 2>&1)
  [ -z "$lines" ] && lines="(logi są puste)"
  echo "$lines" | cut -c1-240 | indent
  echo "         Całość: docker compose logs $1 (w katalogu scenariusza)"
}

# Wykonuje żądanie; ustawia CODE, BODY i HEADERS. Argumenty jak dla curl.
call() {
  local hdr
  hdr=$(mktemp)
  : > "$BODY_FILE"
  CODE=$(curl -s -o "$BODY_FILE" -D "$hdr" -w '%{http_code}' --max-time "${MAX_TIME:-15}" "$@")
  BODY=$(cat "$BODY_FILE")
  HEADERS=$(tr -d '\r' < "$hdr")
  rm -f "$hdr"
}

# expect_status "opis" 200 <argumenty curl>
expect_status() {
  local desc=$1 expected=$2; shift 2
  call "$@"
  if [ "$CODE" = "$expected" ]; then ok "$desc (HTTP $CODE)"; else bad "$desc: oczekiwano HTTP $expected, jest HTTP $CODE. Body: ${BODY:0:300}"; fi
}

# expect_body "opis" 'fragment' <argumenty curl>  (sprawdza też, że HTTP 2xx)
expect_body() {
  local desc=$1 fragment=$2; shift 2
  call "$@"
  if [[ "$CODE" == 2* ]] && grep -qF -- "$fragment" "$BODY_FILE"; then
    ok "$desc"
  else
    bad "$desc: oczekiwano HTTP 2xx i fragmentu $fragment, jest HTTP $CODE. Body: ${BODY:0:300}"
  fi
}

# expect_eq "opis" "wartość" "oczekiwana"
expect_eq() {
  if [ "$2" = "$3" ]; then ok "$1"; else bad "$1: jest '${2:0:200}', oczekiwano '$3'"; fi
}

# expect_logs "opis" serwis 'fragment'
expect_logs() {
  if docker compose logs --no-log-prefix "$2" 2>/dev/null | grep -qF -- "$3"; then
    ok "$1"
  else
    bad "$1: w 'docker compose logs $2' nie ma: $3"
  fi
}

# Wartość pola liczbowego z JSON-a, np. json_num maxHeapMb
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
