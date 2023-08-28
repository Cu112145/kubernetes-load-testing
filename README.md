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