# 10. nginx nie startuje, bo aplikacja jest unhealthy, choć działa

Poziom: **średni**

## Uruchomienie

```bash
cd scenarios/10-kontener-unhealthy
mvn -q package -DskipTests          # buduje target/sklep.jar
docker compose up --build -d
docker compose ps -a
docker compose logs app

# automatyczne sprawdzenie (z katalogu głównego ćwiczeń); samo buduje i uruchamia scenariusz od zera
./scenarios/10-kontener-unhealthy/check.sh
```

## Zgłoszenie

Dodaliśmy nginx przed aplikację (docelowo będzie terminował TLS). Żeby nginx nie przekazywał ruchu do aplikacji, która jeszcze startuje, dodaliśmy healthcheck i `condition: service_healthy`. Teraz `docker compose up -d` po ok. 40 sekundach kończy się błędem:

```
dependency failed to start: container kurs-docker-10-app-1 is unhealthy
```

A przecież aplikacja działa: w logach jest `Started SklepApplication`, a `docker compose exec app wget -qO- localhost:8080/actuator/health` zwraca `{"status":"UP"}`.

**Oczekiwane:** `docker compose up --build -d` kończy się bez błędu, aplikacja ma status `healthy`, a `curl -i http://localhost:8080/api/info` odpowiada przez nginx (nagłówek `Server: nginx`).

**Pytanie dodatkowe:** skąd docker wie, że kontener jest unhealthy, i gdzie zobaczysz wynik ostatnich prób healthchecku?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Na koniec `docker compose down -v`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
