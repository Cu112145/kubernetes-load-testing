# Use a base image with an appropriate OS and dependencies
FROM ubuntu:20.04

# Update the package index and install necessary packages
RUN apt-get update && \
    apt-get install -y apt-transport-https curl

# Download the Kubernetes signing key and add the Kubernetes repository
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

# Install kubelet, kubeadm, and kubectl packages
RUN apt-get update && \
    apt-get install -y kubelet kubeadm kubectl

# Clean up apt cache to reduce the image size
RUN apt-get clean

# Set up necessary directories
RUN mkdir -p /var/lib/kubelet /var/lib/dkubelet/plugins /var/lib/dkubelet/pods /var/run/kubernetes /etc/kubernetes

# Copy kubelet config and certificates from host
COPY /etc/kubernetes/kubelet.conf /etc/kubernetes/
COPY /etc/kubernetes/pki/ca.crt /etc/kubernetes/pki/

# Start kubelet
CMD ["kubelet", "--config=/etc/kubernetes/kubelet.conf", "--kubeconfig=/etc/kubernetes/kubelet.conf", "--cert-dir=/etc/kubernetes/pki", "--root-dir=/var/lib/kubelet", "--v=2", "--alsologtostderr"]
