#!/usr/bin/env bash
# Scenariusz 12-uprawnienia-user: Po dodaniu USER do Dockerfile faktury zwracają 500
# Uruchom: ./scenarios/12-uprawnienia-user/check.sh (z dowolnego katalogu). Skrypt sam buduje i uruchamia scenariusz od zera
# (docker compose down -v, potem up --build), więc kasuje dane z poprzedniego uruchomienia.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 12-uprawnienia-user: Po dodaniu USER do Dockerfile faktury zwracają 500"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
uid=$(docker compose exec -T app id -u 2>/dev/null | tr -d '\r')
if [ -n "$uid" ] && [ "$uid" != "0" ]; then ok "Aplikacja nie działa jako root (uid $uid)"; else bad "Aplikacja działa jako root (uid ${uid:-?}), a wymaganie bezpieczeństwa mówi inaczej"; fi
expect_status "Wystawienie faktury" 201 -X POST "$APP/api/faktury/1001"
expect_eq "Plik faktury jest w /app/faktury" "$(docker compose exec -T app ls /app/faktury 2>/dev/null | tr -d '\r' | grep -c '^faktura-1001.txt$')" "1"
summary
