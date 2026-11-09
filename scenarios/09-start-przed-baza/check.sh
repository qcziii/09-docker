#!/usr/bin/env bash
# Check for scenario 09-start-przed-baza (the description is printed below)
# Run: ./scenarios/09-start-przed-baza/check.sh (from any directory). The script builds and starts the scenario from scratch
# (docker compose down -v, then up --build), so it deletes data from the previous run.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 09-start-przed-baza: Za pierwszym razem aplikacja pada, za drugim działa"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 150
expect_eq "Aplikacja wystartowała za pierwszym razem (restartów: 0)" "$(insp app '{{.RestartCount}}')" "0"
expect_body "Produkty z katalogu" '"name":"Klawiatura mechaniczna"' "$APP/api/products"
summary
