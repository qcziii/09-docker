#!/usr/bin/env bash
# Check for scenario 05-polaczenie-zerwane (the description is printed below)
# Run: ./scenarios/05-polaczenie-zerwane/check.sh (from any directory). The script builds and starts the scenario from scratch
# (docker compose down -v, then up --build), so it deletes data from the previous run.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 05-polaczenie-zerwane: Kontener działa, port jest wystawiony, a curl dostaje zerwane połączenie"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 60
expect_body "Aplikacja odpowiada z hosta" '"status":"running"' "$APP/api/info"
summary
