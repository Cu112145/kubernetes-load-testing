#!/bin/bash

# Build the Docker image using the Dockerfile in the worker-nodes directory
docker build -t kubelet-container ./worker-nodes

# Start multiple Docker containers with different worker names
worker_names=(
    "worker-node-1"
    "worker-node-2"
)

for name in "${worker_names[@]}"; do
    start_command="sudo kubeadm join 135.181.246.248:6443 --token cabdka.skujkk3oz4d6jffj --discovery-token-ca-cert-hash sha256:ae2adf096ca5882939922bcc4aa998cc03a2d08abf913a6a501338d187f75874 --node-name=$name"
    docker run -it --privileged --network host kubelet-container /bin/bash -c "$start_command"
done