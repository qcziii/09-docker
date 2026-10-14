#!/usr/bin/env bash
# Zatrzymuje i usuwa kontenery, sieci i wolumeny wszystkich scenariuszy (projekty compose kurs-docker-*).
export MSYS_NO_PATHCONV=1
projects=$(docker ps -a --format '{{.Label "com.docker.compose.project"}}' | sort -u | grep '^kurs-docker-')
if [ -z "$projects" ]; then
  echo "Brak kontenerów scenariuszy."
  exit 0
fi
for p in $projects; do
  echo "docker compose -p $p down -v"
  docker compose -p "$p" down -v --remove-orphans > /dev/null 2>&1
done
echo "Gotowe."
