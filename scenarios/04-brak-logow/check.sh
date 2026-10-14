#!/usr/bin/env bash
# Scenariusz 04-brak-logow: docker compose logs nie pokazuje logów aplikacji
# Uruchom: ./scenarios/04-brak-logow/check.sh (z dowolnego katalogu). Skrypt sam buduje i uruchamia scenariusz od zera
# (docker compose down -v, potem up --build), więc kasuje dane z poprzedniego uruchomienia.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 04-brak-logow: docker compose logs nie pokazuje logów aplikacji"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_status "Nieistniejące zamówienie zwraca 404" 404 "$APP/api/orders/999"
sleep 1
expect_logs "docker compose logs pokazuje start aplikacji" app "Started SklepApplication"
expect_logs "docker compose logs pokazuje ostrzeżenie o zamówieniu 999" app "Zamówienie 999 nie istnieje"
summary
