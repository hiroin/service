#/bin/bash

kubectl delete replicaset ftps
kubectl delete replicaset grafana
kubectl delete replicaset influxdb
kubectl delete replicaset mysql   
kubectl delete replicaset nginx
kubectl delete replicaset wordpress

kubectl delete service ftps-service
kubectl delete service grafana-service
kubectl delete service influxdb-service
kubectl delete service mysql-service
kubectl delete service nginx-service
kubectl delete service phpmyadmin-service
kubectl delete service wordpress-service 

eval export DOCKER_TLS_VERIFY="";export DOCKER_HOST="";export DOCKER_CERT_PATH="";export MINIKUBE_ACTIVE_DOCKERD=""

kubectl delete -f ./srcs/kubernetes/metallb-system.yaml
