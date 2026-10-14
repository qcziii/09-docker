#!/usr/bin/env bash
# Scenariusz 05-polaczenie-zerwane: Kontener działa, port jest wystawiony, a curl dostaje zerwane połączenie
# Uruchom: ./scenarios/05-polaczenie-zerwane/check.sh (z dowolnego katalogu). Skrypt sam buduje i uruchamia scenariusz od zera
# (docker compose down -v, potem up --build), więc kasuje dane z poprzedniego uruchomienia.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 05-polaczenie-zerwane: Kontener działa, port jest wystawiony, a curl dostaje zerwane połączenie"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 60
expect_body "Aplikacja odpowiada z hosta" '"status":"dziala"' "$APP/api/info"
summary
