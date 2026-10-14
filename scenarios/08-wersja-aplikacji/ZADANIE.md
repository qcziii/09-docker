# 08. Monitoring pokazuje pustą wersję aplikacji

Poziom: **średni**

## Uruchomienie

```bash
cd scenarios/08-wersja-aplikacji
mvn -q package -DskipTests          # buduje target/sklep.jar
docker compose up --build -d
docker compose ps -a
docker compose logs app

# automatyczne sprawdzenie (z katalogu głównego ćwiczeń); samo buduje i uruchamia scenariusz od zera
./scenarios/08-wersja-aplikacji/check.sh
```

## Zgłoszenie

Monitoring odpytuje `/api/info` i pokazuje wersję każdej instancji. Wersję przekazujemy przy budowaniu obrazu (`build.args` w `docker-compose.yml`), a Dockerfile przepisuje ją do zmiennej środowiskowej. Lokalnie z IntelliJ aplikacja pokazuje `nieznana`, co jest OK. Ale z dockera wersja jest... pusta.

```bash
curl http://localhost:8080/api/info
# {"aplikacja":"sklep","wersja":""}
```

**Oczekiwane:** `/api/info` zwraca `"wersja":"2.3.1"`, a wersja dalej pochodzi z `docker-compose.yml`.

**Pytanie dodatkowe:** czym różni się `ARG` od `ENV`? Która z tych wartości jest dostępna w działającym kontenerze, a która tylko podczas budowania?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Na koniec `docker compose down -v`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
