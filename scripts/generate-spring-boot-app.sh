#!/bin/bash

# Function to create file with content
create_file() {
  local FILE_PATH="$1"
  local CONTENT="$2"
  echo -e "$CONTENT" > "$FILE_PATH"
}

# Create directory structure
mkdir -p my-spring-boot-app/src/main/java/com/example
mkdir -p my-spring-boot-app/src/main/resources

# Create build.gradle
BUILD_GRADLE_CONTENT="plugins {
    id 'org.springframework.boot' version '2.5.5'
    id 'io.spring.dependency-management' version '1.0.11.RELEASE'
    id 'java'
}

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    implementation 'org.postgresql:postgresql'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
}

test {
    useJUnitPlatform()
}"

create_file my-spring-boot-app/build.gradle "$BUILD_GRADLE_CONTENT"

# Create Application.java and application.properties
APPLICATION_JAVA_CONTENT="package com.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}"

create_file my-spring-boot-app/src/main/java/com/example/Application.java "$APPLICATION_JAVA_CONTENT"

APPLICATION_PROPERTIES_CONTENT="spring.datasource.url=jdbc:postgresql://localhost:5432/mydatabase
spring.datasource.username=myuser
spring.datasource.password=mypassword
spring.jpa.hibernate.ddl-auto=update
"

create_file my-spring-boot-app/src/main/resources/application.properties "$APPLICATION_PROPERTIES_CONTENT"

# Create Dockerfile
DOCKERFILE_CONTENT="# Stage 1: Build the Spring Boot application
FROM openjdk:11-jdk-slim AS builder
WORKDIR /workspace/app
COPY build.gradle .
COPY src src
RUN chmod +x gradlew
RUN ./gradlew build

# Stage 2: Run the Spring Boot application
FROM openjdk:11-jdk-slim
WORKDIR /app
COPY --from=builder /workspace/app/build/libs/my-spring-boot-app-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT [\"java\", \"-jar\", \"app.jar\"]"

create_file my-spring-boot-app/Dockerfile "$DOCKERFILE_CONTENT"

# Print out message
echo "Spring Boot project 'my-spring-boot-app' has been generated with PostgreSQL support."
