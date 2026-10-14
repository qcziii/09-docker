#!/usr/bin/env bash
# Scenariusz 03-java-opts: Po dodaniu JAVA_OPTS kontener od razu się kończy
# Uruchom: ./scenarios/03-java-opts/check.sh (z dowolnego katalogu). Skrypt sam buduje i uruchamia scenariusz od zera
# (docker compose down -v, potem up --build), więc kasuje dane z poprzedniego uruchomienia.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 03-java-opts: Po dodaniu JAVA_OPTS kontener od razu się kończy"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_body "Aktywny profil docker" '"srodowisko":"docker"' "$APP/api/info"
heap=$(json_num maxHeapMb)
if [ -n "$heap" ] && [ "$heap" -le 256 ]; then
  ok "Limit sterty z JAVA_OPTS działa (maxHeapMb=$heap)"
else
  bad "Sterta nie jest ograniczona do 256 MB (maxHeapMb=${heap:-brak})"
fi
summary
