#!/usr/bin/env bash
# Scenariusz 15-kontener-znika-137: Po ograniczeniu pamięci kontener restartuje się w kółko
# Uruchom: ./scenarios/15-kontener-znika-137/check.sh (z dowolnego katalogu). Skrypt sam buduje i uruchamia scenariusz od zera
# (docker compose down -v, potem up --build), więc kasuje dane z poprzedniego uruchomienia.
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 15-kontener-znika-137: Po ograniczeniu pamięci kontener restartuje się w kółko"
require_docker
stop_other_scenarios
build_jar
compose_up
wait_app 90
expect_eq "Kontener nie został zabity przez OOM killer (OOMKilled)" "$(insp app '{{.State.OOMKilled}}')" "false"
expect_eq "Restarty kontenera" "$(insp app '{{.RestartCount}}')" "0"
expect_eq "Limit pamięci kontenera dalej 512 MB" "$(insp app '{{.HostConfig.Memory}}')" "536870912"
call "$APP/api/info"
heap=$(json_num maxHeapMb)
if [ -n "$heap" ] && [ "$heap" -le 400 ]; then ok "Sterta mieści się w limicie (maxHeapMb=$heap)"; else bad "Sterta nie mieści się w limicie kontenera z zapasem (maxHeapMb=${heap:-brak}, maks. 400)"; fi
expect_body "Raport sprzedaży" '"przetworzonoMb":64' "$APP/api/raport"
expect_body "Drugi raport sprzedaży" '"przetworzonoMb":64' "$APP/api/raport"
expect_eq "Po raportach kontener dalej bez restartów" "$(insp app '{{.RestartCount}}')" "0"
summary
