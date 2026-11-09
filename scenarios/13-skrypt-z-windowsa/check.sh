#!/usr/bin/env bash
# Check for scenario 13-skrypt-z-windowsa (the description is printed below)
# Run: ./scenarios/13-skrypt-z-windowsa/check.sh (from any directory). The script builds and starts the scenario from scratch
# (docker compose down -v, then up --build), so it deletes data from the previous run.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 13-skrypt-z-windowsa: Po zmianie skryptu startowego kontener nie startuje: no such file or directory"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_body "Aplikacja odpowiada" '"status":"running"' "$APP/api/info"
expect_logs "Kontener wystartował przez docker-entrypoint.sh" app "Start sklepu, profil: docker"
summary
