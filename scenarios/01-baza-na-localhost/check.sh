#!/usr/bin/env bash
# Check for scenario 01-baza-na-localhost (the description is printed below)
# Run: ./scenarios/01-baza-na-localhost/check.sh (from any directory). The script builds and starts the scenario from scratch
# (docker compose down -v, then up --build), so it deletes data from the previous run.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 01-baza-na-localhost: W IntelliJ działa, w docker compose aplikacja nie widzi bazy"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_body "Lista produktów z bazy" '"name":"Klawiatura mechaniczna"' "$APP/api/products"
summary
