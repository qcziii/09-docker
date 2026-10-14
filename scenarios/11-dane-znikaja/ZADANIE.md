# 11. Po docker compose down znikają wszystkie zamówienia

Poziom: **średni**

## Uruchomienie

```bash
cd scenarios/11-dane-znikaja
mvn -q package -DskipTests          # buduje target/sklep.jar
docker compose up --build -d
docker compose ps -a
docker compose logs app

# automatyczne sprawdzenie (z katalogu głównego ćwiczeń); samo buduje i uruchamia scenariusz od zera
./scenarios/11-dane-znikaja/check.sh
```

## Zgłoszenie

Dane bazy mają przetrwać restart, więc w compose jest wolumen `dane`. `docker compose restart` faktycznie nic nie psuje, ale po `docker compose down` i ponownym `up -d` wszystkie zamówienia znikają. Nie używamy `down -v`. Wolumen `kurs-docker-11_dane` istnieje (`docker volume ls`).

```bash
curl -X POST http://localhost:8080/api/orders -H 'Content-Type: application/json' -d '{"produkt":"Klawiatura","ilosc":1}'
curl http://localhost:8080/api/orders
docker compose down
docker compose up -d
curl http://localhost:8080/api/orders
```

**Oczekiwane:** zamówienia przetrwają `docker compose down` + `docker compose up -d`.

**Pytanie dodatkowe:** ile wolumenów pokazuje `docker volume ls` po kilku cyklach `down`/`up` i skąd się biorą te z długimi losowymi nazwami?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Na koniec `docker compose down -v`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
