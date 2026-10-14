#!/usr/bin/env bash
# Scenariusz 09-start-przed-baza: Za pierwszym razem aplikacja pada, za drugim działa
# Uruchom: ./scenarios/09-start-przed-baza/check.sh (z dowolnego katalogu). Skrypt sam buduje i uruchamia scenariusz od zera
# (docker compose down -v, potem up --build), więc kasuje dane z poprzedniego uruchomienia.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 09-start-przed-baza: Za pierwszym razem aplikacja pada, za drugim działa"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 150
expect_eq "Aplikacja wystartowała za pierwszym razem (restartów: 0)" "$(insp app '{{.RestartCount}}')" "0"
expect_body "Produkty z katalogu" '"nazwa":"Klawiatura mechaniczna"' "$APP/api/products"
summary
