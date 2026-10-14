#!/usr/bin/env bash
# Scenariusz 11-dane-znikaja: Po docker compose down znikają wszystkie zamówienia
# Uruchom: ./scenarios/11-dane-znikaja/check.sh (z dowolnego katalogu). Skrypt sam buduje i uruchamia scenariusz od zera
# (docker compose down -v, potem up --build), więc kasuje dane z poprzedniego uruchomienia.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 11-dane-znikaja: Po docker compose down znikają wszystkie zamówienia"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
MARKER="Zamowienie-$(date +%s)"
expect_status "Złożenie zamówienia" 201 -X POST "$APP/api/orders" -H 'Content-Type: application/json' -d "{\"produkt\":\"$MARKER\",\"ilosc\":1}"
info "docker compose down (bez -v), potem docker compose up -d"
docker compose down > /dev/null 2>&1
if ! docker compose up -d > "$OUT_FILE" 2>&1; then
  bad "docker compose up -d po down zakończył się błędem"; tail -n 10 "$OUT_FILE" | indent; summary
fi
wait_app 90
expect_body "Zamówienie przetrwało down/up" "$MARKER" "$APP/api/orders"
summary
