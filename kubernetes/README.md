# minikube
minikubeの起動コマンド
sudo minikube start --vm-driver=none --extra-config=apiserver.service-node-port-range=1-65535

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

# nginxのReplicaSetの設定
kubectl apply -f nginx-replicaset.yaml
kubectl get replicaset -o wide
kubectl get pod -o wide

sudo kubectl delete pod [ポッド名]
kubectl get replicaset -o wide
kubectl get pod -o wide

kubectl delete -f nginx-replicaset.yaml

#　nginxのserviceの設定 type: LoadBalancer
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

# その他
minikube ip 
