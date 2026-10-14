FROM eclipse-temurin:21-jre-alpine
# Wymaganie bezpieczeństwa: aplikacja nie może działać jako root
RUN addgroup -S sklep && adduser -S -G sklep sklep
WORKDIR /app
COPY target/sklep.jar app.jar
USER sklep
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
