# 03. Po dodaniu JAVA_OPTS kontener od razu się kończy

Poziom: **łatwy**

## Uruchomienie

```bash
cd scenarios/03-java-opts
mvn -q package -DskipTests          # buduje target/sklep.jar
docker compose up --build -d
docker compose ps -a
docker compose logs app

# automatyczne sprawdzenie (z katalogu głównego ćwiczeń); samo buduje i uruchamia scenariusz od zera
./scenarios/03-java-opts/check.sh
```

## Zgłoszenie

Chcieliśmy ustawiać pamięć JVM i profil Springa z `docker-compose.yml`, bez przebudowywania obrazu. Dodałem zmienną `JAVA_OPTS` w compose i użyłem jej w `ENTRYPOINT`. Od tej pory kontener kończy się zaraz po starcie: `Exited (1)`.

```bash
docker compose ps -a
docker compose logs app
```

**Oczekiwane:** aplikacja działa z profilem `docker` i stertą ograniczoną do 256 MB. `curl http://localhost:8080/api/info` pokazuje `"srodowisko":"docker"` i `maxHeapMb` nie większe niż 256.

**Pytanie dodatkowe:** czym różni się `ENTRYPOINT ["java", "-jar", "app.jar"]` od `ENTRYPOINT java -jar app.jar`? Który proces ma w kontenerze PID 1 w każdym z tych przypadków?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Na koniec `docker compose down -v`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
