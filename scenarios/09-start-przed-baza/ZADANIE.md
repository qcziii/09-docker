# 09. Za pierwszym razem aplikacja pada, za drugim działa

Poziom: **trudny**

## Uruchomienie

```bash
cd scenarios/09-start-przed-baza
mvn -q package -DskipTests          # buduje target/sklep.jar
docker compose up --build -d
docker compose ps -a
docker compose logs app

# automatyczne sprawdzenie (z katalogu głównego ćwiczeń); samo buduje i uruchamia scenariusz od zera
./scenarios/09-start-przed-baza/check.sh
```

## Zgłoszenie

Po `docker compose up` na czystej maszynie aplikacja pada przy starcie. Gdy zrobię `docker compose up -d` drugi raz, wstaje i działa. Na CI, gdzie zawsze startujemy od zera, nie działa nigdy. Przecież mamy `depends_on: db`, więc aplikacja powinna czekać na bazę.

```bash
docker compose down -v
docker compose up --build -d
docker compose ps -a
docker compose logs app
docker compose logs db
```

**Oczekiwane:** po `docker compose down -v` i `docker compose up --build -d` aplikacja wstaje za pierwszym razem, bez restartów, i zwraca produkty: `curl http://localhost:8080/api/products`. Restartowanie aplikacji w kółko (`restart: on-failure`) nie jest rozwiązaniem: chcemy, żeby wstawała raz, gdy baza jest gotowa.

**Pytanie dodatkowe:** co dokładnie sprawdza `depends_on` w krótkiej formie (`- db`)?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Na koniec `docker compose down -v`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
