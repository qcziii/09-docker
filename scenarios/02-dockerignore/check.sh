#!/usr/bin/env bash
# Check for scenario 02-dockerignore (the description is printed below)
# Run: ./scenarios/02-dockerignore/check.sh (from any directory). The script builds and starts the scenario from scratch
# (docker compose down -v, then up --build), so it deletes data from the previous run.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 02-dockerignore: Po dodaniu .dockerignore obraz przestał się budować"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_body "Aplikacja odpowiada" '"status":"running"' "$APP/api/info"
summary
