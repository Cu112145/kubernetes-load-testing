# Use an official Ubuntu 20.04 image as the base
FROM ubuntu:20.04

# Install required packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-transport-https \
    curl \
    ca-certificates \
    gnupg \
    software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# Install Docker (optional, you might need Docker within the container)
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce && \
    rm -rf /var/lib/apt/lists/*

# Add Kubernetes apt repository
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

# Install Kubernetes packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y kubelet kubeadm kubectl && \
    apt-mark hold kubelet kubeadm kubectl && \
    rm -rf /var/lib/apt/lists/*

# Set the entrypoint to start a shell
CMD ["/bin/bash"]
