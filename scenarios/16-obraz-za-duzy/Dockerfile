# Budowanie w dockerze: nie trzeba mieć Javy ani Mavena na komputerze
FROM maven:3.9-eclipse-temurin-21
WORKDIR /app
COPY . .
RUN mvn -B -q package -DskipTests
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "target/sklep.jar"]
