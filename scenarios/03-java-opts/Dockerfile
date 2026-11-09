FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY target/shop.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "$JAVA_OPTS", "-jar", "app.jar"]
