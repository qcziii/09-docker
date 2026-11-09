# The version is passed at build time (build.args in docker-compose.yml)
ARG APP_VERSION=dev

FROM eclipse-temurin:21-jre-alpine
ENV APP_VERSION=${APP_VERSION}
WORKDIR /app
COPY target/shop.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
