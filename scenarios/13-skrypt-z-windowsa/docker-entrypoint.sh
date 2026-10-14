#!/bin/sh
# Skrypt startowy kontenera: przygotowuje katalog tymczasowy i uruchamia aplikację
mkdir -p /tmp/sklep
echo "Start sklepu, profil: ${SPRING_PROFILES_ACTIVE:-domyslny}"
exec java $JAVA_OPTS -Djava.io.tmpdir=/tmp/sklep -jar /app/app.jar
