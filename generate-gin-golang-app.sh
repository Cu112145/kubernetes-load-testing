#!/bin/bash

# Function to create file with content
create_file() {
  local FILE_PATH="$1"
  local CONTENT="$2"
  echo -e "$CONTENT" > "$FILE_PATH"
}

# Create directory structure
mkdir -p my-gin-golang-app

# Create main.go
MAIN_GO_CONTENT="package main

import (
\t\"database/sql\"
\t\"github.com/gin-gonic/gin\"
\t_ \"github.com/lib/pq\"
)

func main() {
\t// Database connection string
\tdbInfo := \"host=postgresdb user=root password=root dbname=mydatabase sslmode=disable\"
\tdb, err := sql.Open(\"postgres\", dbInfo)
\tif err != nil {
\t\tpanic(err)
\t}
\tdefer db.Close()

\tr := gin.Default()
\tr.GET(\"/ping\", func(c *gin.Context) {
\t\tc.JSON(200, gin.H{
\t\t\t\"message\": \"pong\",
\t\t})
\t})
\tr.Run() // listen and serve on 0.0.0.0:8080 (for windows \"localhost:8080\")
}"

create_file my-gin-golang-app/main.go "$MAIN_GO_CONTENT"

# Create go.mod
GO_MOD_CONTENT="module my-gin-golang-app

go 1.17

require (
\tgithub.com/gin-gonic/gin v1.7.7
\tgithub.com/lib/pq v1.10.4
)"

create_file my-gin-golang-app/go.mod "$GO_MOD_CONTENT"

# Create Dockerfile
DOCKERFILE_CONTENT="# Start from the latest golang base image
FROM golang:latest

# Add Maintainer Info
LABEL maintainer=\"example@example.com\"

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build the Go app
RUN go build -o main .

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD [\"./main\"]"

create_file my-gin-golang-app/Dockerfile "$DOCKERFILE_CONTENT"

# Print out message
echo "Gin Golang project 'my-gin-golang-app' has been generated with PostgreSQL support."
