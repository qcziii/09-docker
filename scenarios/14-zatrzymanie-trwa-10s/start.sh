#!/bin/sh
# Start script: prints the configuration and starts the application
echo "Start sklepu (JAVA_OPTS: ${JAVA_OPTS:-brak})"
java $JAVA_OPTS -jar /app/app.jar
