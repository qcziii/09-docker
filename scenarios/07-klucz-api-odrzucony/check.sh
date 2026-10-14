#!/usr/bin/env bash
# Scenariusz 07-klucz-api-odrzucony: Bramka płatności odrzuca klucz API, choć jest poprawny
# Uruchom: ./scenarios/07-klucz-api-odrzucony/check.sh (z dowolnego katalogu). Skrypt sam buduje i uruchamia scenariusz od zera
# (docker compose down -v, potem up --build), więc kasuje dane z poprzedniego uruchomienia.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 07-klucz-api-odrzucony: Bramka płatności odrzuca klucz API, choć jest poprawny"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_status "Płatność przyjęta przez bramkę" 201 -X POST "$APP/api/platnosci?zamowienie=1"
summary
