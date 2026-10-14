# 13. Po zmianie skryptu startowego kontener nie startuje: no such file or directory

Poziom: **średni**

## Uruchomienie

```bash
cd scenarios/13-skrypt-z-windowsa
mvn -q package -DskipTests          # buduje target/sklep.jar
docker compose up --build -d
docker compose ps -a
docker compose logs app

# automatyczne sprawdzenie (z katalogu głównego ćwiczeń); samo buduje i uruchamia scenariusz od zera
./scenarios/13-skrypt-z-windowsa/check.sh
```

## Zgłoszenie

Kolega (pracuje na Windowsie) dodał do skryptu startowego tworzenie katalogu tymczasowego i wypisywanie profilu. Od tego commita kontener nie startuje, u nikogo, także na Macu i na Linuksie w CI. Skrypt wygląda poprawnie, `chmod +x` jest w Dockerfile, plik jest w obrazie.

```bash
docker compose up --build -d
docker compose ps -a
docker compose logs app
# exec /docker-entrypoint.sh: no such file or directory
```

**Oczekiwane:** kontener startuje przez `docker-entrypoint.sh` (w logach `Start sklepu, profil: docker`), `curl http://localhost:8080/api/info` odpowiada. Napraw to tak, żeby problem nie wrócił przy kolejnej edycji na Windowsie.

**Pytanie dodatkowe:** skoro plik istnieje, to czego dokładnie nie może znaleźć system ("no such file or directory")?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Na koniec `docker compose down -v`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
