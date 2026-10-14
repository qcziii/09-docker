# 14. Zatrzymanie kontenera trwa 10 sekund, a zamówienia z kolejki giną

Poziom: **trudny**

## Uruchomienie

```bash
cd scenarios/14-zatrzymanie-trwa-10s
mvn -q package -DskipTests          # buduje target/sklep.jar
docker compose up --build -d
docker compose ps -a
docker compose logs app

# automatyczne sprawdzenie (z katalogu głównego ćwiczeń); samo buduje i uruchamia scenariusz od zera
./scenarios/14-zatrzymanie-trwa-10s/check.sh
```

## Zgłoszenie

Przy każdym wdrożeniu (`docker compose up -d` z nowym obrazem) giną zamówienia, które czekały w kolejce w pamięci. Aplikacja ma przecież `@PreDestroy`, który zapisuje kolejkę przy zamykaniu, i lokalnie (Ctrl+C w IntelliJ) to działa: w logu jest `Zamykanie: zapisano zamówienia z kolejki`. W dockerze tego wpisu nie ma nigdy. Zauważyliśmy też, że zatrzymanie kontenera trwa zawsze równo 10 sekund.

```bash
curl -X POST "http://localhost:8080/api/orders?produkt=Klawiatura"
time docker compose stop app
docker compose ps -a
docker compose logs app
```

**Oczekiwane:** `docker compose stop app` trwa najwyżej kilka sekund, aplikacja kończy się normalnie (kod wyjścia 143) i zapisuje kolejkę (`Zamykanie: zapisano zamówienia z kolejki` w logach).

**Pytanie dodatkowe:** co oznaczają kody wyjścia 137 i 143? Skąd się bierze akurat 10 sekund?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Na koniec `docker compose down -v`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
