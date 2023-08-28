#!/bin/bash

kubectl cluster-info
kubectl config use-context kubernetes-admin@kubernetes

#!/bin/bash

# Update package lists
apt update

# Install Helm if it's not installed
if ! command -v helm &> /dev/null; then
  echo "Installing Helm..."
  curl https://baltocdn.com/helm/signing.asc | apt-key add -
  apt install apt-transport-https --yes
  echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
  apt update
  apt install helm
fi

# Add the Kubernetes Dashboard repository
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

# Update Helm repositories
helm repo update

# Install Kubernetes Dashboard
helm install my-dashboard kubernetes-dashboard/kubernetes-dashboard --namespace kube-system

# Create service account and cluster role binding
cat <<EOL | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: dashboard-admin-sa
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: dashboard-admin-sa
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: dashboard-admin-sa
  namespace: kube-system
EOL

# Get token for dashboard login
DASHBOARD_TOKEN=$(kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep dashboard-admin-sa | awk '{print $1}') | grep "^token:" | awk '{print $2}')

echo "Dashboard Token: $DASHBOARD_TOKEN"

# Run kubectl proxy in background to allow remote access
kubectl proxy --address='0.0.0.0' --accept-hosts='^*$' &
PROXY_PID=$!

# Output instructions for accessing dashboard remotely
echo "==================================================================="
echo "To access the dashboard, navigate to:"
echo "http://<Server_Public_IP>:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/"
echo "Use the following token to log in:"
echo "$DASHBOARD_TOKEN"
echo "==================================================================="
