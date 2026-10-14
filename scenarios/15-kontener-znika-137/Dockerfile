FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY target/sklep.jar app.jar
EXPOSE 8080
# sh -c, żeby $JAVA_OPTS zostało rozwinięte; exec, żeby java była procesem PID 1
ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar app.jar"]
