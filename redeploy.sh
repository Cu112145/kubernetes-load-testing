#!/bin/bash

# Define the list of deployments and services
deployments=("my-spring-boot-app" "my-gin-golang-app" "my-flask-python-app" "postgresdb" "react-frontend")
services=("my-spring-boot-app" "my-gin-golang-app" "my-flask-python-app" "postgresdb" "react-frontend")

# Delete existing deployments and services
echo "Deleting existing deployments and services..."
for dep in "${deployments[@]}"; do
  kubectl delete deployment $dep --ignore-not-found
done

for svc in "${services[@]}"; do
  kubectl delete service $svc --ignore-not-found
done

# Deploy new configurations
echo "Deploying new configurations..."
kubectl apply -f kubernetes_deployments/

echo "Redeployment completed."
