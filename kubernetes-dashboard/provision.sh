#!/bin/bash

# Add Helm repository
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

# Create the kubernetes-dashboard namespace
kubectl create namespace kubernetes-dashboard

# Upgrade and install Kubernetes Dashboard
helm upgrade kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
  --atomic --cleanup-on-fail --install --reset-values \
  --namespace kubernetes-dashboard \
  --values - <<EOF
ingress:
  enabled: true
  hosts:
    - dashboard.example.com
EOF

# Apply user configuration for Dashboard access control
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user-cluster-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

# Create an authentication token for the admin user
kubectl -n kubernetes-dashboard create serviceaccount admin-user
kubectl -n kubernetes-dashboard create clusterrolebinding admin-user-cluster-admin --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:admin-user

# Retrieve the authentication token
token_secret=$(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
token=$(kubectl -n kubernetes-dashboard describe secret $token_secret | grep -E '^token' | awk '{print $2}')

# Output the authentication token
echo "Admin Token: $token"
