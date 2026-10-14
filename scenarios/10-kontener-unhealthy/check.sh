#!/usr/bin/env bash
# Scenariusz 10-kontener-unhealthy: nginx nie startuje, bo aplikacja jest unhealthy, choć działa
# Uruchom: ./scenarios/10-kontener-unhealthy/check.sh (z dowolnego katalogu). Skrypt sam buduje i uruchamia scenariusz od zera
# (docker compose down -v, potem up --build), więc kasuje dane z poprzedniego uruchomienia.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 10-kontener-unhealthy: nginx nie startuje, bo aplikacja jest unhealthy, choć działa"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 60
expect_eq "Healthcheck aplikacji" "$(insp app '{{.State.Health.Status}}')" "healthy"
expect_body "Aplikacja odpowiada przez nginx" '"status":"dziala"' "$APP/api/info"
if echo "$HEADERS" | grep -qi '^server: nginx'; then ok "Odpowiedź przeszła przez nginx"; else bad "Brak nagłówka Server: nginx, odpowiedź nie przeszła przez proxy"; fi
summary
