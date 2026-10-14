# 05. Kontener działa, port jest wystawiony, a curl dostaje zerwane połączenie

Poziom: **średni**

## Uruchomienie

```bash
cd scenarios/05-polaczenie-zerwane
mvn -q package -DskipTests          # buduje target/sklep.jar
docker compose up --build -d
docker compose ps -a
docker compose logs app

# automatyczne sprawdzenie (z katalogu głównego ćwiczeń); samo buduje i uruchamia scenariusz od zera
./scenarios/05-polaczenie-zerwane/check.sh
```

## Zgłoszenie

Kontener jest `Up`, w logach `Tomcat started on port 8080` i `Started SklepApplication`, `docker compose ps` pokazuje `0.0.0.0:8080->8080/tcp`. Mimo to z komputera nie da się połączyć:

```bash
curl -v http://localhost:8080/api/info
# curl: (56) Recv failure: Connection reset by peer   (albo: Empty reply from server)
```

Port 8080 na komputerze nie jest zajęty przez nic innego. Ostatnio wdrażaliśmy zalecenia z audytu bezpieczeństwa.

**Oczekiwane:** `curl http://localhost:8080/api/info` odpowiada. Aplikacja ma być dostępna tylko z tego komputera, nie z sieci (to było zalecenie audytu).

**Pytanie dodatkowe:** jak sprawdzić, czy aplikacja w ogóle odpowiada **wewnątrz** kontenera? Co to mówi o tym, gdzie leży problem?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Na koniec `docker compose down -v`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
