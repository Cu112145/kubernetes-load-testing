#!/bin/bash

#!/bin/bash

export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl cluster-info
kubectl config use-context kubernetes-admin@kubernetes

# Function to clean up background jobs on exit
cleanup() {
  echo "Cleaning up..."
  if [[ ! -z "${PROXY_PID}" ]]; then
    kill -9 ${PROXY_PID}
  fi
  echo "Done."
}

# Trap cleanup function on script exit
trap cleanup EXIT

# Check if port 8001 is in use and kill it if necessary
if lsof -Pi :8001 -sTCP:LISTEN -t >/dev/null ; then
    echo "Port 8001 is in use. Killing the process..."
    kill -9 $(lsof -Pi :8001 -sTCP:LISTEN -t)
fi

# Check if kubectl is available and configured
if ! kubectl cluster-info >/dev/null 2>&1; then
  echo "It seems like you do not have access to a Kubernetes cluster. Make sure you have kubeadmin access."
  exit 1
fi

# Try to get the public IP address using different methods
for method in "ifconfig.me" "ipecho.net/plain" "ident.me"
do
  PUBLIC_IP_ADDRESS=$(curl -s $method)
  if [ -n "$PUBLIC_IP_ADDRESS" ]; then
    break
  fi
done

if [ -z "$PUBLIC_IP_ADDRESS" ]; then
  echo "Could not determine public IP address."
  exit 1
else
  echo "Public IP Address: $PUBLIC_IP_ADDRESS"
fi

# Deploy the Kubernetes Dashboard
echo "Deploying Kubernetes Dashboard..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v3.0.0-alpha0/charts/kubernetes-dashboard.yaml

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
PROXY_PID=$!

# Print the URL for the user
echo "========================================"
echo "Navigate to the following URL to access the Kubernetes Dashboard:"
echo "http://135.181.246.248:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
echo "========================================"
https://135.181.246.248:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
# Print the token for the user to login
echo "Use the following token to log in to the dashboard:"
echo "${DASHBOARD_TOKEN}"
