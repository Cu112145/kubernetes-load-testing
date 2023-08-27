#!/bin/bash

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

# Optional: Open the dashboard in the default browser
# This assumes xdg-open is available, but you could use gnome-open or just manually open the URL
echo "Attempting to open the dashboard in your default browser..."
xdg-open "http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"

# You can also print the URL and ask the user to open it themselves
echo "You can manually open the Kubernetes dashboard by visiting:"
echo "http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"

# Print the token for the user to login
echo "Use the following token to log in to the dashboard:"
echo "${DASHBOARD_TOKEN}"
