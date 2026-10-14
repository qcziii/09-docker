#!/usr/bin/env bash
# Scenariusz 06-plik-env: Zmiana w pliku .env nie dociera do aplikacji
# Uruchom: ./scenarios/06-plik-env/check.sh (z dowolnego katalogu). Skrypt sam buduje i uruchamia scenariusz od zera
# (docker compose down -v, potem up --build), więc kasuje dane z poprzedniego uruchomienia.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 06-plik-env: Zmiana w pliku .env nie dociera do aplikacji"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_body "Waluta z pliku .env" '"waluta":"EUR"' "$APP/api/info"
expect_body "Rabat z pliku .env" '"rabat":10' "$APP/api/info"
summary
