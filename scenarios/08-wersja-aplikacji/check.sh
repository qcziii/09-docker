#!/usr/bin/env bash
# Scenariusz 08-wersja-aplikacji: Monitoring pokazuje pustą wersję aplikacji
# Uruchom: ./scenarios/08-wersja-aplikacji/check.sh (z dowolnego katalogu). Skrypt sam buduje i uruchamia scenariusz od zera
# (docker compose down -v, potem up --build), więc kasuje dane z poprzedniego uruchomienia.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 08-wersja-aplikacji: Monitoring pokazuje pustą wersję aplikacji"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_body "Wersja aplikacji z build.args" '"wersja":"2.3.1"' "$APP/api/info"
summary
