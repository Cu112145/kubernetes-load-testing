#!/bin/bash

# Get public IP address of this machine
PUBLIC_IP_ADDRESS=$(curl -s ifconfig.me)

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
