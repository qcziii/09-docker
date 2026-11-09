#!/usr/bin/env bash
# Check for scenario 06-plik-env (the description is printed below)
# Run: ./scenarios/06-plik-env/check.sh (from any directory). The script builds and starts the scenario from scratch
# (docker compose down -v, then up --build), so it deletes data from the previous run.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 06-plik-env: Zmiana w pliku .env nie dociera do aplikacji"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_body "Waluta z pliku .env" '"currency":"EUR"' "$APP/api/info"
expect_body "Rabat z pliku .env" '"discount":10' "$APP/api/info"
summary
