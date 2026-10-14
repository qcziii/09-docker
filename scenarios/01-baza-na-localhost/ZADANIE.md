# 01. W IntelliJ działa, w docker compose aplikacja nie widzi bazy

Poziom: **łatwy**

## Uruchomienie

```bash
cd scenarios/01-baza-na-localhost
mvn -q package -DskipTests          # buduje target/sklep.jar
docker compose up --build -d
docker compose ps -a
docker compose logs app

# automatyczne sprawdzenie (z katalogu głównego ćwiczeń); samo buduje i uruchamia scenariusz od zera
./scenarios/01-baza-na-localhost/check.sh
```

## Zgłoszenie

Do tej pory uruchamiałem sklep z IntelliJ, a PostgreSQL w dockerze z wystawionym portem 5432. Wszystko działało. Teraz chcemy odpalać całość jednym `docker compose up`, więc dopisałem aplikację do `docker-compose.yml`. Baza wstaje (jest nawet healthcheck), ale kontener aplikacji kończy się zaraz po starcie: `Exited (1)`.

```bash
docker compose ps -a
docker compose logs app
```

**Oczekiwane:** `curl http://localhost:8080/api/products` zwraca listę produktów z bazy. Uruchamianie z IntelliJ (z `application.yml`) ma dalej działać.

**Pytanie dodatkowe:** dlaczego w `docker-compose.yml` port bazy nie jest wystawiony (`ports`), a aplikacja w kontenerze i tak może się z nią połączyć?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Na koniec `docker compose down -v`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
