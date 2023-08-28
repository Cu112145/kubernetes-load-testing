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

