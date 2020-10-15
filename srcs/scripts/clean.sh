#/bin/bash

kubectl delete replicaset ftps
kubectl delete replicaset grafana
kubectl delete replicaset nginx
kubectl delete replicaset wordpress
kubectl delete -f ./srcs/kubernetes/mysql-replicaset_with_pvc.yaml
kubectl delete -f ./srcs/kubernetes/influxdb-replicaset_with_pvc.yaml

kubectl delete service ftps-service
kubectl delete service grafana-service
kubectl delete service influxdb-service
kubectl delete service mysql-service
kubectl delete service nginx-service
kubectl delete service phpmyadmin-service
kubectl delete service wordpress-service 

eval export DOCKER_TLS_VERIFY="";export DOCKER_HOST="";export DOCKER_CERT_PATH="";export MINIKUBE_ACTIVE_DOCKERD=""

kubectl delete -f ./srcs/kubernetes/metallb-system.yaml

#docker image rm hkamiya/nginx:000
#docker image rm hkamiya/influxdb:000
#docker image rm hkamiya/wordpress:000
#docker image rm hkamiya/grafana:000
#docker image rm hkamiya/ftps:000
#docker image rm hkamiya/mysql:000

sudo sed -i '/^192\.168\.2\.2/d' /etc/hosts
