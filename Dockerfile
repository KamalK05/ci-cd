# =======================================================
# STAGE 1: Build the application (Must be named 'build')
# =======================================================
FROM gradle:8.12-jdk21 AS build

WORKDIR /Volumes/Development/Sample-Wkspace/personal-repos/ci-cd
COPY . .
RUN chmod +x gradlew
# Run your gradle build command to generate the JAR file
RUN ./gradlew bootJar -x test --no-daemon

# =======================================================
# STAGE 2: Run the application
# =======================================================
FROM edenhill/kafkacat AS runtime

FROM eclipse-temurin:21-jre-alpine

EXPOSE 8082

# This will now perfectly match the 'AS build' stage above!
COPY --from=build /Volumes/Development/Sample-Wkspace/personal-repos/ci-cd/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]