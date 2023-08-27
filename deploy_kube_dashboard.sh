#!/bin/bash

# Function to check if a port is in use and kill the process using it
check_and_kill_port() {
  PORT=$1
  PID=$(sudo lsof -t -i:$PORT)
  if [ ! -z "$PID" ]; then
    echo "Port $PORT is in use. Killing the process..."
    sudo kill -9 $PID
  else
    echo "Port $PORT is available."
  fi
}

# Check if port 8001 is in use
check_and_kill_port 8001

# Get public IP address of this machine
PUBLIC_IP_ADDRESS=$(curl -s ifconfig.me)
# Fallback to another service if the above fails
[ -z "$PUBLIC_IP_ADDRESS" ] && PUBLIC_IP_ADDRESS=$(curl -s api.ipify.org)
# Fallback to localhost if all fail
[ -z "$PUBLIC_IP_ADDRESS" ] && PUBLIC_IP_ADDRESS="localhost"

# Deploy the Kubernetes Dashboard
echo "Deploying Kubernetes Dashboard..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml

# Create a service account for the dashboard and get its token
echo "Creating service account for dashboard..."
kubectl create serviceaccount dashboard-admin-sa

echo "Creating ClusterRoleBinding for dashboard..."
kubectl create clusterrolebinding dashboard-admin-sa \
  --clusterrole=cluster-admin \
  --serviceaccount=default:dashboard-admin-sa

# Fetch the token for the dashboard
echo "Fetching the dashboard token..."
DASHBOARD_TOKEN=$(kubectl describe secret $(kubectl -n default get secret | grep dashboard-admin-sa | awk '{print $1}') | grep "token:" | awk '{print $2}')

echo "Dashboard Token: ${DASHBOARD_TOKEN}"

# Forward the dashboard to a port so you can access it
echo "Starting kubectl proxy in the background..."
kubectl proxy &

# Print the URL for the user
echo "========================================"
echo "Navigate to the following URL to access the Kubernetes Dashboard:"
echo "http://${PUBLIC_IP_ADDRESS}:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
echo "========================================"

# Print the token for the user to login
echo "Use the following token to log in to the dashboard:"
echo "${DASHBOARD_TOKEN}"
