# 15. Po ograniczeniu pamięci kontener restartuje się w kółko

Poziom: **trudny**

## Uruchomienie

```bash
cd scenarios/15-kontener-znika-137
mvn -q package -DskipTests          # buduje target/sklep.jar
docker compose up --build -d
docker compose ps -a
docker compose logs app

# automatyczne sprawdzenie (z katalogu głównego ćwiczeń); samo buduje i uruchamia scenariusz od zera
./scenarios/15-kontener-znika-137/check.sh
```

## Zgłoszenie

Administrator klastra wprowadził limit 512 MB pamięci na instancję sklepu (jest w `docker-compose.yml`). Od tej pory kontener restartuje się w kółko. W logach aplikacji nie ma żadnego błędu, często nie ma w nich nic albo są urwane w połowie startu.

```bash
docker compose ps -a
# STATUS: Restarting (137) 2 seconds ago
docker compose logs app
```

**Oczekiwane:** aplikacja działa w limicie 512 MB (limitu nie wolno zwiększać ani usuwać), nie restartuje się, a raport sprzedaży (`curl http://localhost:8080/api/raport`) działa. `/api/info` pokazuje rozmiar sterty (`maxHeapMb`): ma się mieścić w limicie z zapasem, czyli najwyżej 400 MB.

**Pytanie dodatkowe:** dlaczego w logach aplikacji nie ma żadnego `OutOfMemoryError`? Ile pamięci dostałaby sterta, gdyby w `JAVA_OPTS` nie było żadnych ustawień pamięci?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Na koniec `docker compose down -v`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
