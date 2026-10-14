#!/usr/bin/env bash
# Scenariusz 13-skrypt-z-windowsa: Po zmianie skryptu startowego kontener nie startuje: no such file or directory
# Uruchom: ./scenarios/13-skrypt-z-windowsa/check.sh (z dowolnego katalogu). Skrypt sam buduje i uruchamia scenariusz od zera
# (docker compose down -v, potem up --build), więc kasuje dane z poprzedniego uruchomienia.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 13-skrypt-z-windowsa: Po zmianie skryptu startowego kontener nie startuje: no such file or directory"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_body "Aplikacja odpowiada" '"status":"dziala"' "$APP/api/info"
expect_logs "Kontener wystartował przez docker-entrypoint.sh" app "Start sklepu, profil: docker"
summary
