cd .. &&
source .env && docker-compose build
cd k8s &&
minikube cache add react_test_umbrella_client:latest && minikube cache add react_test_umbrella_migrator:latest && minikube cache add react_test_umbrella_phoenix:latest
./apply.sh
kubectl port-forward service/phoenix 4002:80