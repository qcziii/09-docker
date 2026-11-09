#!/usr/bin/env bash
# Check for scenario 12-uprawnienia-user (the description is printed below)
# Run: ./scenarios/12-uprawnienia-user/check.sh (from any directory). The script builds and starts the scenario from scratch
# (docker compose down -v, then up --build), so it deletes data from the previous run.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 12-uprawnienia-user: Po dodaniu USER do Dockerfile faktury zwracają 500"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
uid=$(docker compose exec -T app id -u 2>/dev/null | tr -d '\r')
if [ -n "$uid" ] && [ "$uid" != "0" ]; then ok "Aplikacja nie działa jako root (uid $uid)"; else bad "Aplikacja działa jako root (uid ${uid:-?}), a wymaganie bezpieczeństwa mówi inaczej"; fi
expect_status "Wystawienie faktury" 201 -X POST "$APP/api/invoices/1001"
expect_eq "Plik faktury jest w /app/invoices" "$(docker compose exec -T app ls /app/invoices 2>/dev/null | tr -d '\r' | grep -c '^invoice-1001.txt$')" "1"
summary
