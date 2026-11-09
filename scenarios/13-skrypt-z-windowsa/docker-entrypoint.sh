#!/bin/sh
# Container start script: prepares the temp directory and starts the application
mkdir -p /tmp/shop
echo "Start sklepu, profil: ${SPRING_PROFILES_ACTIVE:-domyslny}"
exec java $JAVA_OPTS -Djava.io.tmpdir=/tmp/shop -jar /app/app.jar
