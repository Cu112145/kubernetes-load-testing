#!/bin/bash
set -e

# Remove or comment problematic repositories
sudo sed -i '/cli.github.com\/packages/d' /etc/apt/sources.list.d/*.list

# Remove duplicates for Kubernetes
sudo awk '!seen[$0]++' /etc/apt/sources.list.d/kubernetes.list > temp && sudo mv temp /etc/apt/sources.list.d/kubernetes.list


echo "Disabling swap...."
sudo swapoff -a
sudo sed -i.bak '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo "Installing necessary dependencies...."
sudo apt-get update -q
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

echo "Setting up hostname...."
sudo hostnamectl set-hostname "k8s-master"
PUBLIC_IP_ADDRESS=$(hostname -I | cut -d" " -f 1)
echo "${PUBLIC_IP_ADDRESS} k8s-master" | sudo tee -a /etc/hosts

echo "Removing existing installations...."
sudo apt-get purge -y containerd.io kubeadm kubectl kubelet kubernetes-cni || true
sudo apt autoremove -y || true
sudo rm -rf /etc/kubernetes /var/lib/etcd $HOME/.kube/config || true

echo "Installing containerd...."
sudo apt-get update -q
sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd

echo "Setting up Kubernetes Package Repository..."
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

echo "Installing Kubernetes..."
sudo apt-get update -q
sudo apt-get install -y kubeadm=1.22.0-00 kubelet=1.22.0-00 kubectl=1.22.0-00
sudo apt-mark hold kubelet kubeadm kubectl

echo "Initializing Kubernetes..."
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --cri-socket /run/containerd/containerd.sock

sudo kubeadm reset & kubeadm init --pod-network-cidr=10.244.0.0/16 --cri-socket /run/containerd/containerd.sock
# echo "Configuring kubectl..."
# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Installing Flannel..."
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

echo "Kubernetes Installation finished..."
echo "Waiting 30 seconds for the cluster to go online..."
sleep 30

echo "Testing Kubernetes namespaces... "
kubectl get pods --all-namespaces
echo "Testing Kubernetes nodes... "
kubectl get nodes

echo "All ok ;)"
