#!/usr/bin/env bash
# Scenariusz 01-baza-na-localhost: W IntelliJ działa, w docker compose aplikacja nie widzi bazy
# Uruchom: ./scenarios/01-baza-na-localhost/check.sh (z dowolnego katalogu). Skrypt sam buduje i uruchamia scenariusz od zera
# (docker compose down -v, potem up --build), więc kasuje dane z poprzedniego uruchomienia.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 01-baza-na-localhost: W IntelliJ działa, w docker compose aplikacja nie widzi bazy"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_body "Lista produktów z bazy" '"nazwa":"Klawiatura mechaniczna"' "$APP/api/products"
summary
