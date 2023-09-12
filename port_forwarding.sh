#!/bin/bash

# Your Kubernetes namespace. Replace it if you're using a different one.
NAMESPACE="app-v1"

# Setup port-forwarding for each service
# This will make the service accessible on the corresponding localhost port
kubectl port-forward svc/my-flask-python-app 8082:8082 -n $NAMESPACE &
kubectl port-forward svc/v1-app-release-flask-python-app 8083:8082 -n $NAMESPACE &
kubectl port-forward svc/v1-app-release-gin-golang-app 8081:8081 -n $NAMESPACE &
kubectl port-forward svc/v1-app-release-spring-boot-app 8080:8080 -n $NAMESPACE &
kubectl port-forward svc/v1-app-release-react-frontend 8084:80 -n $NAMESPACE &

# Print out the forwarded ports
echo "Port-forwarding setup is complete."
echo "You can now access the services on this machine using the following localhost ports:"
echo "Flask service 1: 8082"
echo "Flask service 2: 8083"
echo "Gin service: 8081"
echo "Spring Boot service: 8080"
echo "React Frontend: 8084"

# Keep the script running so that the background jobs don't terminate
wait
