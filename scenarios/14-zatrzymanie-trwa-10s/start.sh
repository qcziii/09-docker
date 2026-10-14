#!/bin/sh
# Skrypt startowy: wypisuje konfigurację i uruchamia aplikację
echo "Start sklepu (JAVA_OPTS: ${JAVA_OPTS:-brak})"
java $JAVA_OPTS -jar /app/app.jar
