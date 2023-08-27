#!/bin/bash

# Disable swap
echo "Disabling swap...."
sudo swapoff -a
sudo sed -i.bak '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Install dependencies
echo "Installing necessary dependencies...."
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Set hostname
echo "Setting up hostname...."
sudo hostnamectl set-hostname "k8s-master"
PUBLIC_IP_ADDRESS=$(hostname -I | cut -d" " -f 1)
echo "${PUBLIC_IP_ADDRESS} k8s-master" | sudo tee -a /etc/hosts

# Remove previous installations
echo "Removing existing installations...."
sudo apt-get purge -y containerd.io kubeadm kubectl kubelet kubernetes-cni
sudo apt autoremove -y
sudo rm -rf /etc/kubernetes /var/lib/etcd /var/lib/docker $HOME/.kube/config

# Install containerd
echo "Installing containerd...."
sudo apt-get update
sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd

# Add Kubernetes apt repository
echo "Setting up Kubernetes Package Repository..."
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo add-apt-repository "deb https://apt.kubernetes.io/ kubernetes-xenial main"

# Install Kubernetes
echo "Installing Kubernetes..."
sudo apt-get update
sudo apt-get install -y kubeadm=1.22.0-00 kubelet=1.22.0-00 kubectl=1.22.0-00
sudo apt-mark hold kubelet kubeadm kubectl

# Initialize Kubernetes
echo "Initializing Kubernetes..."
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --cri-socket /run/containerd/containerd.sock

# Configure kubectl
echo "Configuring kubectl..."
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Flannel
echo "Installing Flannel..."
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

echo "Kubernetes Installation finished..."
echo "Waiting 30 seconds for the cluster to go online..."
sudo sleep 30

# Test the setup
echo "Testing Kubernetes namespaces... "
kubectl get pods --all-namespaces
echo "Testing Kubernetes nodes... "
kubectl get nodes

echo "All ok ;)"
