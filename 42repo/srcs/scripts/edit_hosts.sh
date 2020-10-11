#!/bin/bash

sudo sed -i '/wordpress-service/d' /etc/hosts
IP=`kubectl get service -o wide | grep wordpress-service  | awk '{print $4}'`
sudo sh -c "echo $IP wordpress-service >> /etc/hosts"

sudo sed -i '/nginx-service/d' /etc/hosts
IP=`kubectl get service -o wide | grep nginx-service  | awk '{print $4}'`
sudo sh -c "echo $IP nginx-service >> /etc/hosts"

sudo sed -i '/ftps-service/d' /etc/hosts
IP=`kubectl get service -o wide | grep ftps-service  | awk '{print $4}'`
sudo sh -c "echo $IP ftps-service >> /etc/hosts"

sudo sed -i '/grafana-service/d' /etc/hosts
IP=`kubectl get service -o wide | grep grafana-service  | awk '{print $4}'`
sudo sh -c "echo $IP grafana-service >> /etc/hosts"

sudo sed -i '/phpmyadmin-service/d' /etc/hosts
IP=`kubectl get service -o wide | grep phpmyadmin-service  | awk '{print $4}'`
sudo sh -c "echo $IP phpmyadmin-service >> /etc/hosts"
