#!/usr/bin/env bash
# Check for scenario 03-java-opts (the description is printed below)
# Run: ./scenarios/03-java-opts/check.sh (from any directory). The script builds and starts the scenario from scratch
# (docker compose down -v, then up --build), so it deletes data from the previous run.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 03-java-opts: Po dodaniu JAVA_OPTS kontener od razu się kończy"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_body "Aktywny profil docker" '"environment":"docker"' "$APP/api/info"
heap=$(json_num maxHeapMb)
if [ -n "$heap" ] && [ "$heap" -le 256 ]; then
  ok "Limit sterty z JAVA_OPTS działa (maxHeapMb=$heap)"
else
  bad "Sterta nie jest ograniczona do 256 MB (maxHeapMb=${heap:-brak})"
fi
summary
