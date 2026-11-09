FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY target/shop.jar app.jar
COPY start.sh /start.sh
RUN chmod +x /start.sh
EXPOSE 8080
ENTRYPOINT ["/start.sh"]
