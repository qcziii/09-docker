FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY target/sklep.jar app.jar
COPY start.sh /start.sh
RUN chmod +x /start.sh
EXPOSE 8080
ENTRYPOINT ["/start.sh"]
