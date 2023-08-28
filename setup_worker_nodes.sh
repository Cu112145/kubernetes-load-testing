#!/bin/bash

# Create Docker containers for worker nodes
docker run -d --name=worker-node-1 --privileged ubuntu:20.04 tail -f /dev/null
docker run -d --name=worker-node-2 --privileged ubuntu:20.04 tail -f /dev/null

# Function to install Kubernetes components in a container
install_kubernetes() {
    container_name=$1
    docker exec -it $container_name /bin/bash -c \
        "apt-get update && apt-get install -y apt-transport-https curl && \
        curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
        echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list && \
        apt-get update && apt-get install -y kubelet kubeadm kubectl"
}

# Install Kubernetes components in worker node containers
install_kubernetes worker-node-1
install_kubernetes worker-node-2

# Join worker nodes to the cluster
join_command="kubeadm join 135.181.246.248:6443 --token cabdka.skujkk3oz4d6jffj --discovery-token-ca-cert-hash sha256:ae2adf096ca5882939922bcc4aa998cc03a2d08abf913a6a501338d187f75874"

docker exec -it worker-node-1 /bin/bash -c "$join_command"
docker exec -it worker-node-2 /bin/bash -c "$join_command"
