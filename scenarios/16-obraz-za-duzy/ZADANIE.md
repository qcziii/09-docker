# 16. Obraz waży kilkaset MB i zawiera kod źródłowy oraz Mavena

Poziom: **średni**

## Uruchomienie

```bash
cd scenarios/16-obraz-za-duzy
docker compose up --build -d
docker compose ps -a
docker compose logs app

# automatyczne sprawdzenie (z katalogu głównego ćwiczeń); samo buduje i uruchamia scenariusz od zera
./scenarios/16-obraz-za-duzy/check.sh
```

## Zgłoszenie

Żeby nie wymagać Javy ani Mavena na serwerze CI, budujemy aplikację w dockerze. Działa, ale:
- obraz ma kilkaset MB (rejestr firmowy przyjmuje obrazy do 450 MB, liczone jak w `docker image ls`),
- skaner bezpieczeństwa zgłasza, że w obrazie jest kod źródłowy, Maven i pełne JDK,
- każda, nawet jednoliniowa zmiana w kodzie powoduje pobranie wszystkich zależności od nowa.

```bash
docker compose build
docker image ls kurs-docker-16-app
docker history kurs-docker-16-app
docker compose up -d
docker compose exec app ls /app
```

**Oczekiwane:** obraz ma mniej niż 450 MB, nie zawiera Mavena ani plików `.java`, aplikacja odpowiada pod `http://localhost:8080/api/info`. Budowanie dalej odbywa się w dockerze (bez `mvn` na komputerze). Bonus: zmiana w `src/` nie powoduje ponownego pobierania zależności.

Pierwsze budowanie trwa kilka minut (pobieranie obrazu Mavena i zależności).

**Pytanie dodatkowe:** które warstwy obrazu zajmują najwięcej miejsca (`docker history`)? Dlaczego `COPY . .` przed `mvn package` psuje cache?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Na koniec `docker compose down -v`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
