# kubernetes-load-testing


export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl apply -f .
kubectl describe services
kubectl describe pods 

kubectl get deployments
kubectl get services

kubectl delete deployment my-spring-boot-app
kubectl delete deployment my-flask-python-app
kubectl describe pod my-flask-python-app

kubectl port-forward svc/my-flask-python-app 8082:8082

./build_docker_images.sh my-spring-boot-app:latest my-gin-golang-app:latest my-flask-python-app:latest postgresdb:latest react-frontend:latest ansible-terraform:latest\n

minikube image load my-spring-boot-app:latest my-gin-golang-app:latest my-flask-python-app:latest postgresdb:latest react-frontend:latest ansible-terraform:latest

minikube dashboard

sudo kubeadm reset -f & sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --cri-socket /run/containerd/containerd.sock --apiserver-advertise-address=135.181.246.248
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl config use-context kubernetes-admin@kubernetes
kubectl cluster-info 
kubectl get nodes && kubectl get pods --all-namespaces
To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf