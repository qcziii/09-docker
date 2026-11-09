# Build inside docker: no need to have Java or Maven on your machine
FROM maven:3.9-eclipse-temurin-21
WORKDIR /app
COPY . .
RUN mvn -B -q package -DskipTests
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "target/shop.jar"]
