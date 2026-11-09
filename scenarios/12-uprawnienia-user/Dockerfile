FROM eclipse-temurin:21-jre-alpine
# Security requirement: the application must not run as root
RUN addgroup -S shop && adduser -S -G shop shop
WORKDIR /app
COPY target/shop.jar app.jar
USER shop
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
