# Docker i Docker Compose dla aplikacji Spring Boot: warsztat z troubleshootingu

Masz przed sobą 16 aplikacji sklepu, które źle działają w kontenerach. Każda to osobny projekt z `Dockerfile`, `docker-compose.yml`, opisem zgłoszenia od użytkownika i testem, który przejdzie dopiero po naprawie. Twoim zadaniem jest znaleźć przyczynę, poprawić obraz, konfigurację compose lub aplikację i umieć wyjaśnić, **jak** do przyczyny doszedłeś.

## Wymagania

- Java 21 i Maven 3.9+ (aplikację budujemy na komputerze, obraz kopiuje gotowy jar)
- Docker z Docker Compose v2 (na Windows: Docker Desktop), polecenie `docker compose` (ze spacją)
- `bash` i `curl` (na Windows: Git Bash)
- wolny port 8080
- internet przy pierwszym uruchomieniu: obrazy `eclipse-temurin:21-jre-alpine`, `postgres:17-alpine`, `nginx:1.27-alpine`, `maven:3.9-eclipse-temurin-21`

**Windows / Git Bash:** Git Bash zamienia argumenty zaczynające się od `/` na ścieżki Windows (`docker compose exec app ls /app` staje się `ls C:/Program Files/Git/app`). Skrypty z repo są na to odporne. Jeśli uruchamiasz coś ręcznie i widzisz w wyniku `C:/Program Files/Git/...`, poprzedź polecenie `MSYS_NO_PATHCONV=1` (np. `MSYS_NO_PATHCONV=1 docker compose exec app ls /app`) albo użyj podwójnego ukośnika (`//app`). Do interaktywnej powłoki w kontenerze w Git Bash czasem potrzebne jest `winpty docker compose exec app sh`.

Stos: Spring Boot 4.0, Java 21, obrazy `eclipse-temurin` (alpine), PostgreSQL 17.

## Architektura

```
klient (curl) ──> localhost:8080 ──> [kontener app: sklep] ──> [kontener db: PostgreSQL]  (część scenariuszy)
                                      (w scenariuszu 10 przed aplikacją stoi nginx)
```

Każdy scenariusz to osobny projekt compose (`kurs-docker-NN`) z własną aplikacją, siecią i wolumenami. Wszystkie publikują aplikację na porcie 8080, więc naraz działa jeden scenariusz. Baza danych nie jest publikowana na hoście, więc nie koliduje z lokalnym PostgreSQL.

## Jak pracować

```bash
cd scenarios/01-baza-na-localhost
mvn -q package -DskipTests        # buduje target/sklep.jar (scenariusz 16 buduje w dockerze)
docker compose up --build -d
docker compose ps -a              # stan kontenerów, kody wyjścia
docker compose logs app           # logi aplikacji

# automatyczne sprawdzenie, z katalogu głównego repo
./scenarios/01-baza-na-localhost/check.sh

# sprzątanie po scenariuszu (w jego katalogu)
docker compose down -v
```

Przeczytaj `ZADANIE.md` w katalogu scenariusza, odtwórz problem, znajdź przyczynę, popraw i uruchom ponownie. Scenariusz jest rozwiązany, gdy `check.sh` wypisze `WYNIK: wszystkie sprawdzenia przeszły`.

`check.sh` robi wszystko od zera: buduje jar, zatrzymuje kontenery innych scenariuszy, robi `docker compose down -v` (kasuje też wolumeny scenariusza), potem `docker compose up --build -d` i sprawdza wynik. Kontenery zostają uruchomione, żeby można było je dalej oglądać.

Po każdej zmianie `Dockerfile` lub kodu pamiętaj o `--build` (a po zmianie kodu także o `mvn package`). Bez tego compose uruchomi stary obraz.

## Narzędzia

```bash
docker compose ps -a                         # stan i kod wyjścia (Exited (1), Restarting (137), healthy/unhealthy)
docker compose logs -f app                   # logi na żywo; -t dodaje znaczniki czasu
docker compose config                        # docker-compose.yml po podstawieniu zmiennych: co compose NAPRAWDĘ uruchomi
docker compose exec app sh                   # powłoka w działającym kontenerze (alpine: sh, nie bash)
docker compose exec app env                  # zmienne środowiskowe procesu w kontenerze
docker compose exec app wget -qO- localhost:8080/actuator/health   # zapytanie z wnętrza kontenera (curl-a tam nie ma)
docker compose top app                       # procesy w kontenerze (kto jest PID 1?)
docker inspect <kontener>                    # wszystko: State (ExitCode, OOMKilled, Health), Mounts, Config.Env
docker inspect --format '{{json .State}}' <kontener>
docker image ls / docker history <obraz>     # rozmiar obrazu i jego warstw
docker volume ls / docker network ls
docker stats                                 # zużycie pamięci i CPU na żywo
docker run --rm -it --entrypoint sh <obraz>  # obejrzyj obraz, gdy kontener nie chce wystartować
```

Nazwy kontenerów mają postać `kurs-docker-NN-app-1`, obrazów `kurs-docker-NN-app`.

## Port 8080 zajęty

Jeśli `docker compose up` zgłasza `port is already allocated` albo `bind: address already in use`, port zajmuje inny program albo kontener (np. aplikacja z poprzednich zajęć). `docker ps` pokazuje kontenery z portami, `./scripts/stop-all.sh` zatrzymuje wszystkie scenariusze z tego repo. Na Windows w PowerShellu:

```powershell
Get-NetTCPConnection -LocalPort 8080 -State Listen | Select-Object LocalPort, OwningProcess, @{n='Name';e={(Get-Process -Id $_.OwningProcess).ProcessName}}
```

## Scenariusze

| # | Zgłoszenie | Poziom |
|---|---|---|
| 01 | W IntelliJ działa, w docker compose aplikacja nie widzi bazy | łatwy |
| 02 | Po dodaniu .dockerignore obraz przestał się budować | łatwy |
| 03 | Po dodaniu JAVA_OPTS kontener od razu się kończy | łatwy |
| 04 | docker compose logs nie pokazuje logów aplikacji | łatwy |
| 05 | Kontener działa, port jest wystawiony, a curl dostaje zerwane połączenie | średni |
| 06 | Zmiana w pliku .env nie dociera do aplikacji | średni |
| 07 | Bramka płatności odrzuca klucz API, choć jest poprawny | średni |
| 08 | Monitoring pokazuje pustą wersję aplikacji | średni |
| 09 | Za pierwszym razem aplikacja pada, za drugim działa | trudny |
| 10 | nginx nie startuje, bo aplikacja jest unhealthy, choć działa | średni |
| 11 | Po docker compose down znikają wszystkie zamówienia | średni |
| 12 | Po dodaniu USER do Dockerfile faktury zwracają 500 | średni |
| 13 | Po zmianie skryptu startowego kontener nie startuje: no such file or directory | średni |
| 14 | Zatrzymanie kontenera trwa 10 sekund, a zamówienia z kolejki giną | trudny |
| 15 | Po ograniczeniu pamięci kontener restartuje się w kółko | trudny |
| 16 | Obraz waży kilkaset MB i zawiera kod źródłowy oraz Mavena | średni |

## Zasady

- Naprawiasz pliki w katalogu scenariusza: `Dockerfile`, `docker-compose.yml`, `.dockerignore`, skrypty startowe, konfigurację i kod aplikacji. Nie zmieniaj `check.sh` ani `scripts/`.
- Wymagania ze zgłoszenia są częścią zadania. Jeśli zgłoszenie mówi, że limitu pamięci nie wolno zwiększać albo aplikacja nie może działać jako root, rozwiązanie, które to łamie, nie jest rozwiązaniem.
- Zanim cokolwiek zmienisz, odpowiedz sobie na pytania: **w którym miejscu to się psuje?** Budowanie obrazu, start kontenera, start aplikacji, sieć czy dane? I: **co compose naprawdę uruchamia?** (`docker compose config`, `docker inspect`).
- Czytaj logi od dołu: najważniejsza jest ostatnia przyczyna (`Caused by:`). Gdy logów nie ma, patrz na kod wyjścia kontenera.
- Przy pracy w repo zrób własną gałąź, żeby łatwo wrócić do zepsutej wersji (`git checkout -- scenarios/NN-...`).

Wszystkie aplikacje buduje naraz `mvn package -DskipTests` w katalogu głównym. Na koniec zajęć: `./scripts/stop-all.sh`.
