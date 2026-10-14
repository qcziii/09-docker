# 06. Zmiana w pliku .env nie dociera do aplikacji

Poziom: **średni**

## Uruchomienie

```bash
cd scenarios/06-plik-env
mvn -q package -DskipTests          # buduje target/sklep.jar
docker compose up --build -d
docker compose ps -a
docker compose logs app

# automatyczne sprawdzenie (z katalogu głównego ćwiczeń); samo buduje i uruchamia scenariusz od zera
./scenarios/06-plik-env/check.sh
```

## Zgłoszenie

Wersję sklepu na rynek niemiecki konfigurujemy plikiem `.env` obok `docker-compose.yml`. Ustawiłem walutę EUR i rabat 10%, zrobiłem `docker compose up --build -d`, a sklep dalej pokazuje ceny w PLN, bez rabatu. Port z `.env` działa (zmieniłem na chwilę na 8081 i aplikacja wstała na 8081), więc plik jest czytany.

```bash
curl http://localhost:8080/api/info
curl http://localhost:8080/api/products/1
```

**Oczekiwane:** `/api/info` zwraca `"waluta":"EUR"` i `"rabat":10`. Wartości mają dalej pochodzić z pliku `.env`.

**Pytanie dodatkowe:** jakim poleceniem zobaczysz `docker-compose.yml` po podstawieniu wszystkich zmiennych? A jakim zmienne środowiskowe, które naprawdę ma proces w kontenerze?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Na koniec `docker compose down -v`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
