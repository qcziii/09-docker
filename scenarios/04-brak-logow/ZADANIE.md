# 04. docker compose logs nie pokazuje logów aplikacji

Poziom: **łatwy**

## Uruchomienie

```bash
cd scenarios/04-brak-logow
mvn -q package -DskipTests          # buduje target/sklep.jar
docker compose up --build -d
docker compose ps -a
docker compose logs app

# automatyczne sprawdzenie (z katalogu głównego ćwiczeń); samo buduje i uruchamia scenariusz od zera
./scenarios/04-brak-logow/check.sh
```

## Zgłoszenie

Na serwerze testowym logi zbiera agent, który czyta je z dockera (to samo, co pokazuje `docker logs`). Od kiedy sklep działa w kontenerze, nie ma tam nic poza logo Springa. Dziś klient dostał 404 przy zamówieniu i nie mamy żadnego śladu w logach.

```bash
curl -i http://localhost:8080/api/orders/999
docker compose logs app
```

**Oczekiwane:** `docker compose logs app` pokazuje logi aplikacji, w tym start (`Started SklepApplication`) i ostrzeżenie o nieistniejącym zamówieniu. Zapis do pliku może zostać.

**Pytanie dodatkowe:** gdzie są teraz logi aplikacji i co się z nimi stanie po `docker compose down`? Jak je odczytać bez zmiany konfiguracji?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Na koniec `docker compose down -v`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
