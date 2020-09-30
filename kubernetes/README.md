# minikube
minikubeの起動コマンド
sudo minikube start --vm-driver=none --extra-config=apiserver.service-node-port-range=1-65535
minikube start --extra-config=apiserver.service-node-port-range=1-65535

minikubeのステータス確認
sudo minikube status

ダッシュボードを起動
sudo minikube dashboard

minikubeの終了
sudo minikube stop

#　nginxのpodの設定
sudo kubectl apply -f nginx-pod.yaml
sudo kubectl get pod -o wide
sudo kubectl describe pod nginx
sudo kubectl exec -it nginx-pod -- sh
wget -S --no-check-certificate http://127.0.0.1:8080/ -O -

sudo kubectl delete pod nginx-pod
sudo kubectl delete -f nginx-pod.yaml

#　nginxのserviceの設定
kubectl apply -f nginx-service.yaml
kubectl get service

kubectl delete -f nginx-service.yaml
kubectl get service [サービス名]

#　nginxのserviceへの接続確認
kubectl apply -f bastion.yaml
kubectl get pod -o wide
IPアドレス確認
kubectl exec -it bastion -- bash
apt update && apt install -y curl && apt install -y wget
curl -i http://172.17.0.6/
curl -i http://nginx-service/
wget -S --no-check-certificate http://172.17.0.6/ -O -
wget -S --no-check-certificate https://172.17.0.6/ -O -
wget -S --no-check-certificate http://nginx-service/ -O -
wget -S --no-check-certificate https://nginx-service/ -O -

#　nginxのserviceへの接続確認 type: LoadBalancer
minikube service nginx-service --url
wget -S --no-check-certificate http://172.17.0.2/ -O -

# nginxのReplicaSetの設定
kubectl apply -f nginx-replicaset.yaml
kubectl get replicaset -o wide
kubectl get pod -o wide

sudo kubectl delete pod [ポッド名]
kubectl get replicaset -o wide
kubectl get pod -o wide

kubectl delete -f nginx-replicaset.yaml

#　nginxのserviceの設定 type: NodePort
kubectl apply -f nginx-service.yaml
kubectl get service
kubectl describe services nginx-service
minikube service  nginx-service --url  
http://10.0.2.15:2394
http://10.0.2.15:39737

# MetalLBについて
# https://blog.cybozu.io/entry/2019/03/25/093000
# MetalLBのインストール
# https://metallb.universe.tf/installation/
# 準備
# see what changes would be made, returns nonzero returncode if different
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system
# actually apply the changes, returns nonzero returncode on errors only
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

# マニフェストによるインストール
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

# 確認コマンド
# https://ervikrant06.github.io/kubernetes/metallb-LB-on-minikube/
kubectl get ns
kubectl get all -n metallb-system

# configmapの設定
# https://metallb.universe.tf/configuration/
kubectl apply -f metallb-system.yaml
kubectl get namespace
kubectl get configmap --namespace=metallb-system config
kubectl describe configmap --namespace=metallb-system config

kubectl delete configmap --namespace=metallb-system config

# nginxのserviceの設定 type: LoadBalancer
# https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/
kubectl apply -f nginx-service.yaml
kubectl get service
kubectl describe services nginx-service
wget -S --no-check-certificate http://172.17.0.6/ -O -
wget -S --no-check-certificate https://172.17.0.6/ -O -

kubectl delete -f nginx-service.yaml

# 20200924
# ftpsのReplicaSetの設定
kubectl apply -f ftps-replicaset.yaml
kubectl get replicaset -o wide
kubectl get pod -o wide

sudo kubectl delete pod [ポッド名]
kubectl get replicaset -o wide
kubectl get pod -o wide

kubectl delete -f ftps-replicaset.yaml

# ---------------------------
# ftpsのserviceの設定
# ---------------------------
# type: NodePortで設定
kubectl apply -f ftps-service.yaml
kubectl get service
kubectl describe services ftps-service

kubectl exec -it ftps-replicaset-fqzz5 -- sh
lftp -u test 127.0.0.1
Password : test

kubectl exec -it bastion -- bash
apt update && apt install -y lftp
lftp -u test 10.104.255.227

kubectl get service
CLUSTER-IPを確認
lftp -u test [CLUSTER-IP]

# type: LoadBalancerで設定
kubectl apply -f ftps-service.yaml
kubectl get service
kubectl get pod
kubectl exec -it ftps-replicaset-fqzz5 -- sh
lftp -u test [EXTERNAL-IP]

# configを変更する場合はmetallb-systemのポッドを全部削除
# https://github.com/metallb/metallb/issues/348
kubectl get pods -n metallb-system
kubectl delete po -n metallb-system --all
kubectl get pods -n metallb-system

# 20200925
# mysqlのReplicaSetの設定
kubectl apply -f mysql-replicaset.yaml
kubectl get replicaset -o wide
kubectl get pod -o wide
kubectl exec -it mysql-replicaset-j6ks5 -- sh

mysql -h 127.0.0.1 -P 3306 -u mysql -pmysql
show databases;
use mysql; 
show tables;
SELECT user, Host FROM user;

kubectl delete -f mysql-replicaset.yaml

# ---------------------------
# mysqlのserviceの設定
# ---------------------------
kubectl apply -f mysql-service.yaml
kubectl get service
kubectl describe services mysql-service

kubectl delete -f mysql-service.yaml

# ---------------------------
# PersistentVolumeの設定
# https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/
<!-- mkdir /tmp/hkamiya_data ← setup.shに必要 -->
kubectl apply -f pv-volume.yaml
kubectl get pv -o wide

<!-- kubectl apply -f pv-claim.yaml
kubectl get pv mysql-pv-volume
kubectl get pvc mysql-pv-claim -->

kubectl apply -f mysql-replicaset-merge.yaml
kubectl get replicaset
kubectl get pod
kubectl describe pod [ポッド名]
kubectl exec -it mysql-replicaset-kwdnr -- sh

kubectl delete -f pv-volume.yaml
kubectl delete -f mysql-replicaset-merge.yaml

# ---------------------------
# phpmyadminのserviceの設定
# ---------------------------
kubectl apply -f phpmyadmin-service.yaml
kubectl get service
kubectl delete -f phpmyadmin-service.yaml

# その他
minikube ip 

# dockerのminikubeのdockerに接続する
eval $(minikube docker-env)
# ホストで動いているdockerに接続する
eval export DOCKER_TLS_VERIFY="";export DOCKER_HOST="";export DOCKER_CERT_PATH="";export MINIKUBE_ACTIVE_DOCKERD=""

