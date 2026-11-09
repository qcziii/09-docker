#!/usr/bin/env bash
# Check for scenario 08-wersja-aplikacji (the description is printed below)
# Run: ./scenarios/08-wersja-aplikacji/check.sh (from any directory). The script builds and starts the scenario from scratch
# (docker compose down -v, then up --build), so it deletes data from the previous run.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 08-wersja-aplikacji: Monitoring pokazuje pustą wersję aplikacji"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_body "Wersja aplikacji z build.args" '"version":"2.3.1"' "$APP/api/info"
summary
