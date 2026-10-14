# 07. Bramka płatności odrzuca klucz API, choć jest poprawny

Poziom: **średni**

## Uruchomienie

```bash
cd scenarios/07-klucz-api-odrzucony
mvn -q package -DskipTests          # buduje target/sklep.jar
docker compose up --build -d
docker compose ps -a
docker compose logs app

# automatyczne sprawdzenie (z katalogu głównego ćwiczeń); samo buduje i uruchamia scenariusz od zera
./scenarios/07-klucz-api-odrzucony/check.sh
```

## Zgłoszenie

Podpinamy bramkę płatności (na razie sandbox). Klucz testowy skopiowałem z panelu bramki do `docker-compose.yml`, sprawdziłem trzy razy, że jest identyczny. Mimo to każda płatność kończy się błędem 502, a w logach bramka odrzuca klucz.

```bash
curl -i -X POST "http://localhost:8080/api/platnosci?zamowienie=1"
docker compose logs app
```

**Oczekiwane:** płatność zostaje przyjęta (HTTP 201).

**Pytanie dodatkowe:** w aplikacji są wystawione `/actuator/env` i `/actuator/configprops`. Co pokazują dla klucza i czy to bezpieczne na produkcji?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Na koniec `docker compose down -v`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
