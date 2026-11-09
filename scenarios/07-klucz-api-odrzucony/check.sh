#!/usr/bin/env bash
# Check for scenario 07-klucz-api-odrzucony (the description is printed below)
# Run: ./scenarios/07-klucz-api-odrzucony/check.sh (from any directory). The script builds and starts the scenario from scratch
# (docker compose down -v, then up --build), so it deletes data from the previous run.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 07-klucz-api-odrzucony: Bramka płatności odrzuca klucz API, choć jest poprawny"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_status "Płatność przyjęta przez bramkę" 201 -X POST "$APP/api/payments?orderId=1"
summary
