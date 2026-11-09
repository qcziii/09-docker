FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY target/shop.jar app.jar
EXPOSE 8080
# sh -c so that $JAVA_OPTS gets expanded; exec so that java is PID 1
ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar app.jar"]
