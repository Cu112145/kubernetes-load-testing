#!/bin/bash

# Create the directory if it doesn't exist
mkdir -p kubernetes_deployments

# Function to create Kubernetes YAML file
generate_yaml() {
  echo "$1" > "kubernetes_deployments/$2.yaml"
}

# PostgreSQL Deployment and Service
generate_yaml \
"apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgresdb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgresdb
  template:
    metadata:
      labels:
        app: postgresdb
    spec:
      containers:
      - name: postgresdb
        image: my_postgres_image
        env:
        - name: POSTGRES_USER
          value: \"root\"
        - name: POSTGRES_PASSWORD
          value: \"root\"
        - name: POSTGRES_DB
          value: \"mydatabase\"
        ports:
        - containerPort: 5432
---
apiVersion: v1
kind: Service
metadata:
  name: postgresdb
spec:
  selector:
    app: postgresdb
  ports:
    - protocol: TCP
      port: 5432
      targetPort: 5432" \
"postgres"

# Spring Boot Java application
generate_yaml \
"apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-spring-boot-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-spring-boot-app
  template:
    metadata:
      labels:
        app: my-spring-boot-app
    spec:
      containers:
      - name: my-spring-boot-app
        image: my-spring-boot-app
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: my-spring-boot-app
spec:
  selector:
    app: my-spring-boot-app
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080" \
"spring-boot-app"

# Gin Golang application
generate_yaml \
"apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-gin-golang-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-gin-golang-app
  template:
    metadata:
      labels:
        app: my-gin-golang-app
    spec:
      containers:
      - name: my-gin-golang-app
        image: my-gin-golang-app
        ports:
        - containerPort: 8081
---
apiVersion: v1
kind: Service
metadata:
  name: my-gin-golang-app
spec:
  selector:
    app: my-gin-golang-app
  ports:
    - protocol: TCP
      port: 8081
      targetPort: 8081" \
"gin-golang-app"

# Flask Python application
generate_yaml \
"apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-flask-python-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-flask-python-app
  template:
    metadata:
      labels:
        app: my-flask-python-app
    spec:
      containers:
      - name: my-flask-python-app
        image: my-flask-python-app
        ports:
        - containerPort: 8082
---
apiVersion: v1
kind: Service
metadata:
  name: my-flask-python-app
spec:
  selector:
    app: my-flask-python-app
  ports:
    - protocol: TCP
      port: 8082
      targetPort: 8082" \
"flask-python-app"

# React Frontend
generate_yaml \
"apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: react-frontend
  template:
    metadata:
      labels:
        app: react-frontend
    spec:
      containers:
      - name: react-frontend
        image: react-frontend
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: react-frontend
spec:
  selector:
    app: react-frontend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80" \
"react-frontend"

# Print out a message to indicate success
echo "Kubernetes YAML files have been generated in the kubernetes_deployments directory."
