# 12. Po dodaniu USER do Dockerfile faktury zwracają 500

Poziom: **średni**

## Uruchomienie

```bash
cd scenarios/12-uprawnienia-user
mvn -q package -DskipTests          # buduje target/shop.jar
docker compose up --build -d
docker compose ps -a
docker compose logs app

# automatyczne sprawdzenie (z katalogu głównego ćwiczeń); samo buduje i uruchamia scenariusz od zera
./scenarios/12-uprawnienia-user/check.sh
```

## Zgłoszenie

Po audycie bezpieczeństwa dodaliśmy do Dockerfile użytkownika i `USER`, żeby aplikacja nie działała jako root. Aplikacja startuje, katalog produktów działa, ale wystawianie faktur zwraca 500.

```bash
curl -i -X POST http://localhost:8080/api/invoices/1001
docker compose logs app
```

**Oczekiwane:** faktura się wystawia (HTTP 201), plik ląduje w `/app/invoices` w kontenerze, a aplikacja dalej **nie** działa jako root.

**Pytanie dodatkowe:** co się stanie, gdy na `/app/invoices` podepniesz nowy, pusty wolumen nazwany? A co przy bind mouncie katalogu z hosta (na Linuksie)?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Na koniec `docker compose down -v`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
