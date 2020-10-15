#/bin/bash

# kubeコマンドとminikubeコマンド実行時の権限変更
sudo chmod -R 777 ~/.minikube
sudo chmod -R 777 ~/.kube

# すでにクラスタが構築されている場合は、すべて初期化
./srcs/scripts/clean.sh

# dcokerのコンテナの位置をデフォルトに設定
eval export DOCKER_TLS_VERIFY="";export DOCKER_HOST="";export DOCKER_CERT_PATH="";export MINIKUBE_ACTIVE_DOCKERD=""

# lftpの設定
sudo apt-get install lftp
if [ ! -e ~/.lftprc ];then
	echo "set ssl:verify-certificate no" > ~/.lftprc
fi
cat ~/.lftprc | grep "ssl:verify-certificate"
ret=$?
if [ $ret -eq 1 ];then
	echo "set ssl:verify-certificate no" >> ~/.lftprc
fi

# minikubeの起動
minikube stop
sudo rm /tmp/juju*
sudo minikube start --vm-driver=none --extra-config=apiserver.service-node-port-range=1-65535
ret=$?
if [ $ret -ne 0 ];then
	exit
fi

# kubeコマンドとminikubeコマンド実行時の権限変更
sudo chmod -R 777 ~/.minikube
sudo chmod -R 777 ~/.kube

# imageの生成
docker build -t hkamiya/mysql:000 ./srcs/mysql
docker build -t hkamiya/ftps:000 ./srcs/ftps
docker build -t hkamiya/grafana:000 ./srcs/grafana
docker build -t hkamiya/influxdb:000 ./srcs/influxDB
docker build -t hkamiya/nginx:000 ./srcs/nginx
docker build -t hkamiya/wordpress:000 ./srcs/wordpress

# metalLBの起動
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f ./srcs/kubernetes/metallb-system.yaml

# クラスタの作成
kubectl apply -f ./srcs/kubernetes/mysql-replicaset_with_pvc.yaml
kubectl apply -f ./srcs/kubernetes/mysql-service.yaml
kubectl apply -f ./srcs/kubernetes/ftps-replicaset.yaml
kubectl apply -f ./srcs/kubernetes/ftps-service.yaml
kubectl apply -f ./srcs/kubernetes/grafana-replicaset.yaml
kubectl apply -f ./srcs/kubernetes/grafana-service.yaml
kubectl apply -f ./srcs/kubernetes/influxdb-replicaset_with_pvc.yaml
kubectl apply -f ./srcs/kubernetes/influxdb-service.yaml
kubectl apply -f ./srcs/kubernetes/nginx-replicaset.yaml
kubectl apply -f ./srcs/kubernetes/nginx-service.yaml
kubectl apply -f ./srcs/kubernetes/phpmyadmin-service.yaml
kubectl apply -f ./srcs/kubernetes/wordpress-replicaset.yaml
kubectl apply -f ./srcs/kubernetes/wordpress-service.yaml

#コンテナ初期化
./srcs/scripts/edit_hosts.sh

#ダッシュボードを起動
sudo minikube dashboard




