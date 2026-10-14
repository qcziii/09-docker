# 02. Po dodaniu .dockerignore obraz przestał się budować

Poziom: **łatwy**

## Uruchomienie

```bash
cd scenarios/02-dockerignore
mvn -q package -DskipTests          # buduje target/sklep.jar
docker compose up --build -d
docker compose ps -a
docker compose logs app

# automatyczne sprawdzenie (z katalogu głównego ćwiczeń); samo buduje i uruchamia scenariusz od zera
./scenarios/02-dockerignore/check.sh
```

## Zgłoszenie

Budowanie obrazu trwało długo, bo docker wysyłał do budowania cały katalog. Kolega poradził dodać `.dockerignore`. Teraz `docker compose up --build` kończy się błędem, choć plik `target/sklep.jar` na pewno istnieje (`ls target`).

```bash
mvn -q package -DskipTests
ls -l target/sklep.jar
docker compose build
```

**Oczekiwane:** obraz się buduje, `curl http://localhost:8080/api/info` odpowiada. Budowanie dalej nie wysyła niepotrzebnych plików.

**Pytanie dodatkowe:** co to jest kontekst budowania (`transferring context` w wyniku `docker build`) i dlaczego jego rozmiar ma znaczenie?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Na koniec `docker compose down -v`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
