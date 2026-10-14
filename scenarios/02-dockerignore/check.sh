#!/usr/bin/env bash
# Scenariusz 02-dockerignore: Po dodaniu .dockerignore obraz przestał się budować
# Uruchom: ./scenarios/02-dockerignore/check.sh (z dowolnego katalogu). Skrypt sam buduje i uruchamia scenariusz od zera
# (docker compose down -v, potem up --build), więc kasuje dane z poprzedniego uruchomienia.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 02-dockerignore: Po dodaniu .dockerignore obraz przestał się budować"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_body "Aplikacja odpowiada" '"status":"dziala"' "$APP/api/info"
summary
