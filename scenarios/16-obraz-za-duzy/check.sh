#!/usr/bin/env bash
# Scenariusz 16-obraz-za-duzy: Obraz waży kilkaset MB i zawiera kod źródłowy oraz Mavena
# Uruchom: ./scenarios/16-obraz-za-duzy/check.sh (z dowolnego katalogu). Skrypt sam buduje i uruchamia scenariusz od zera
# (docker compose down -v, potem up --build), więc kasuje dane z poprzedniego uruchomienia.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 16-obraz-za-duzy: Obraz waży kilkaset MB i zawiera kod źródłowy oraz Mavena"
require_docker
stop_other_scenarios
compose_up
wait_app 300
img=$(insp app '{{.Image}}')
mb=$(( $(docker image inspect -f '{{.Size}}' "$img" | tr -d '\r') / 1024 / 1024 ))
if [ "$mb" -lt 450 ]; then ok "Rozmiar obrazu: $mb MB"; else bad "Obraz ma $mb MB, limit rejestru to 450 MB"; fi
expect_eq "W obrazie nie ma Mavena" "$(docker compose exec -T app sh -c 'command -v mvn || echo brak' | tr -d '\r')" "brak"
expect_eq "W obrazie nie ma kodu źródłowego (*.java)" "$(docker compose exec -T app sh -c 'find / -xdev -name "*.java" 2>/dev/null | wc -l' | tr -d '\r ')" "0"
expect_body "Aplikacja odpowiada" '"status":"dziala"' "$APP/api/info"
summary
