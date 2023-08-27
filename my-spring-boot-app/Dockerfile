# Stage 1: Initialize the Gradle Wrapper using the Gradle image
FROM gradle:7.2-jdk11 AS init
WORKDIR /workspace/app
COPY build.gradle .
RUN gradle wrapper

# Stage 2: Build the Spring Boot application
FROM openjdk:11-jdk-slim AS builder
WORKDIR /workspace/app

# Copy the Gradle Wrapper generated in the first stage
COPY --from=init /workspace/app/gradlew .
COPY --from=init /workspace/app/gradle ./gradle
RUN chmod +x ./gradlew

# Copy the build.gradle and src code
COPY build.gradle .
COPY src src

# Run the Gradle build
RUN ./gradlew build

# Stage 3: Run the Spring Boot application
FROM openjdk:11-jdk-slim
WORKDIR /app
COPY --from=builder /workspace/app/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
# Expose port 8080 to the outside world
EXPOSE 8080
