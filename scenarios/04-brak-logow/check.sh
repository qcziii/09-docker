#!/usr/bin/env bash
# Check for scenario 04-brak-logow (the description is printed below)
# Run: ./scenarios/04-brak-logow/check.sh (from any directory). The script builds and starts the scenario from scratch
# (docker compose down -v, then up --build), so it deletes data from the previous run.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 04-brak-logow: docker compose logs nie pokazuje logów aplikacji"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_status "Nieistniejące zamówienie zwraca 404" 404 "$APP/api/orders/999"
sleep 1
expect_logs "docker compose logs pokazuje start aplikacji" app "Started ShopApplication"
expect_logs "docker compose logs pokazuje ostrzeżenie o zamówieniu 999" app "Zamówienie 999 nie istnieje"
summary
