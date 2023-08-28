#!/bin/bash

# Stop Kubernetes services
systemctl stop kubelet
systemctl stop docker
systemctl stop containerd

# Etcd Cleanup
# Uncomment this section if you have access to etcd cluster
# ETCDCTL_API=3 etcdctl --endpoints=$ENDPOINTS member remove $ETCD_MEMBER_ID

# Remove Directories and Files
rm -rf /var/lib/kubelet
rm -rf /etc/cni/net.d
rm -f /etc/kubernetes/admin.conf
rm -f $HOME/.kube/config

# Clean Containers
# Remove all containers managed by containerd
containerd ctr -n=k8s.io c ls -q | xargs -r containerd ctr -n=k8s.io c rm

# Reset Iptables
iptables --flush
iptables -tnat --flush

# If you had set any ipvs rules
# ipvsadm --clear

# Re-initialize
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --cri-socket /run/containerd/containerd.sock --apiserver-advertise-address=135.181.246.248

# Reload services
systemctl daemon-reload
systemctl start kubelet
systemctl start docker
systemctl start containerd

# Reminder to check logs
echo "Remember to check the logs of failing components if the cluster does not initialize correctly."
