# kubernetes-load-testing

helm install v1-app-release kubernetes_chart/ -n app-v1
helm uninstall v1-app-release -n app-v1


export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl apply -f .
kubectl describe services
kubectl describe pods 

kubectl get deployments
kubectl get services

kubectl get pods --all-namespaces
kubectl logs v1-app-release-gin-golang-app-f8fc4d96f-n9nqt


kubectl delete deployment my-spring-boot-app
kubectl delete deployment my-flask-python-app
kubectl describe pod my-flask-python-app

kubectl port-forward svc/my-flask-python-app 8082:8082

./build_and_load_images.sh spring-boot-app:latest gin-golang-app:latest flask-python-app:latest postgresdb:latest react-frontend:latest ansible-terraform:latest\n

kubectl apply -f kubernetes_deployments/

minikube dashboard

ssh -L 8080:10.105.104.215:80 root@135.181.246.248
ssh -L 43501:127.0.0.1:43501 root@135.181.246.248

ssh -L 8080:127.0.0.1:44989 root@135.181.246.248
ssh -L 30022:192.168.49.2:30022 root@135.181.246.248
