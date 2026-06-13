# Stage 1: Build the application
FROM gradle:8-jdk17 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle bootJar --no-daemon

# Stage 2: Run the application
FROM edenhill/kafkacat AS runtime
FROM openjdk:17-slim
EXPOSE 8080
COPY --from=build build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]