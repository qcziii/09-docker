#!/usr/bin/env bash
# Scenariusz 14-zatrzymanie-trwa-10s: Zatrzymanie kontenera trwa 10 sekund, a zamówienia z kolejki giną
# Uruchom: ./scenarios/14-zatrzymanie-trwa-10s/check.sh (z dowolnego katalogu). Skrypt sam buduje i uruchamia scenariusz od zera
# (docker compose down -v, potem up --build), więc kasuje dane z poprzedniego uruchomienia.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 14-zatrzymanie-trwa-10s: Zatrzymanie kontenera trwa 10 sekund, a zamówienia z kolejki giną"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_status "Zamówienie trafia do kolejki" 202 -X POST "$APP/api/orders?produkt=Klawiatura"
expect_status "Drugie zamówienie trafia do kolejki" 202 -X POST "$APP/api/orders?produkt=Mysz"
info "docker compose stop app (mierzę czas)"
start=$(date +%s)
docker compose stop app > /dev/null 2>&1
took=$(( $(date +%s) - start ))
if [ "$took" -le 6 ]; then ok "Zatrzymanie trwało $took s"; else bad "Zatrzymanie trwało $took s (docker czekał i zabił kontener)"; fi
expect_eq "Kod wyjścia kontenera (143 = zakończony przez SIGTERM)" "$(insp app '{{.State.ExitCode}}')" "143"
expect_logs "Aplikacja zapisała kolejkę przy zamykaniu" app "Zamykanie: zapisano zamówienia z kolejki (2)"
summary
