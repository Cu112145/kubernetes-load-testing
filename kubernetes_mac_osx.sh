#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$@" >/dev/null 2>&1
}

# Install Homebrew if not already installed
if ! command_exists brew; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install or Update kubectl
if command_exists kubectl; then
  echo "kubectl found. Updating..."
  brew upgrade kubectl
else
  echo "kubectl not found. Installing..."
  brew install kubectl
fi

# Install or Update VirtualBox
if command_exists virtualbox; then
  echo "VirtualBox found. Skipping installation."
else
  echo "VirtualBox not found. Installing..."
  brew install --cask virtualbox
fi

# Install or Update Minikube
if command_exists minikube; then
  echo "Minikube found. Updating..."
  brew upgrade minikube
else
  echo "Minikube not found. Installing..."
  brew install minikube
fi

# Start Minikube
echo "Starting Minikube..."
minikube start

# Enable addons
echo "Enabling Minikube addons..."
minikube addons enable ingress
minikube addons enable dashboard

# Set kubeconfig
echo "Setting KUBECONFIG..."
export KUBECONFIG=$HOME/.kube/config

# Show cluster information
echo "Cluster information:"
kubectl cluster-info

echo "Minikube dashboard:"
minikube dashboard

echo "Setup completed."
