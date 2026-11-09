#!/usr/bin/env bash
# Check for scenario 10-kontener-unhealthy (the description is printed below)
# Run: ./scenarios/10-kontener-unhealthy/check.sh (from any directory). The script builds and starts the scenario from scratch
# (docker compose down -v, then up --build), so it deletes data from the previous run.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 10-kontener-unhealthy: nginx nie startuje, bo aplikacja jest unhealthy, choć działa"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 60
expect_eq "Healthcheck aplikacji" "$(insp app '{{.State.Health.Status}}')" "healthy"
expect_body "Aplikacja odpowiada przez nginx" '"status":"running"' "$APP/api/info"
if echo "$HEADERS" | grep -qi '^server: nginx'; then ok "Odpowiedź przeszła przez nginx"; else bad "Brak nagłówka Server: nginx, odpowiedź nie przeszła przez proxy"; fi
summary
