#!/usr/bin/env bash
# Check for scenario 14-zatrzymanie-trwa-10s (the description is printed below)
# Run: ./scenarios/14-zatrzymanie-trwa-10s/check.sh (from any directory). The script builds and starts the scenario from scratch
# (docker compose down -v, then up --build), so it deletes data from the previous run.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 14-zatrzymanie-trwa-10s: Zatrzymanie kontenera trwa 10 sekund, a zamówienia z kolejki giną"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_status "Zamówienie trafia do kolejki" 202 -X POST "$APP/api/orders?product=Klawiatura"
expect_status "Drugie zamówienie trafia do kolejki" 202 -X POST "$APP/api/orders?product=Mysz"
info "docker compose stop app (mierzę czas)"
start=$(date +%s)
docker compose stop app > /dev/null 2>&1
took=$(( $(date +%s) - start ))
if [ "$took" -le 6 ]; then ok "Zatrzymanie trwało $took s"; else bad "Zatrzymanie trwało $took s (docker czekał i zabił kontener)"; fi
expect_eq "Kod wyjścia kontenera (143 = zakończony przez SIGTERM)" "$(insp app '{{.State.ExitCode}}')" "143"
expect_logs "Aplikacja zapisała kolejkę przy zamykaniu" app "Zamykanie: zapisano zamówienia z kolejki (2)"
summary
