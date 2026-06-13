# Stage 2: Run the application
FROM edenhill/kafkacat AS runtime

# CHANGE THIS LINE: Use a supported JDK 17 image
FROM eclipse-temurin:17-jre-alpine

EXPOSE 8082  # <-- Keeping your new port 8082 config!
COPY --from=build build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]