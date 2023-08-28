#!/bin/bash

# Function to build Docker images
build_image() {
    local path=$1
    local tag=$2
    echo "Building Docker image for $path with tag $tag..."
    docker build -t $tag $path
}

# Check if the user has provided tags for the images
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ] || [ -z "$6" ]; then
    echo "Usage: ./build_docker_images.sh <spring_boot_tag> <gin_golang_tag> <flask_python_tag> <postgres_tag> <react_frontend_tag> <ansible_terraform_tag>"
    exit 1
fi

# Build Spring Boot Java application
build_image "./spring-boot-app" $1

# Build Gin Golang application
build_image "./gin-golang-app" $2

# Build Flask Python application
build_image "./flask-python-app" $3

# Build PostgreSQL database service
build_image "./postgresdb" $4

# Build React Frontend
build_image "./frontend" $5

# Build Ansible and Terraform
build_image "." $6

echo "All Docker images built successfully."

minikube image load $1 $2 $3 $4 $5
