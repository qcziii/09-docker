# Wersję podajemy przy budowaniu (build.args w docker-compose.yml)
ARG APP_VERSION=dev

FROM eclipse-temurin:21-jre-alpine
ENV APP_VERSION=${APP_VERSION}
WORKDIR /app
COPY target/sklep.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
