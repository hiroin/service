FROM alpine:3.12

RUN apk update
RUN apk add openssl
RUN apk add nginx
RUN apk add openrc 
RUN apk add vim

#nginxの設定
RUN mkdir /etc/nginx/ssl \
 && openssl genrsa -out /etc/nginx/ssl/server.key 2048 \
 && openssl req -new -key /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.csr -subj "/C=JP/ST=Tokyo/L=/O=/OU=/CN=localhost" \
 && openssl x509 -days 3650 -req -signkey /etc/nginx/ssl/server.key -in /etc/nginx/ssl/server.csr -out /etc/nginx/ssl/server.crt
COPY ./srcs/default.conf /etc/nginx/conf.d/default.conf
RUN echo 'index.html' > /var/www/localhost/htdocs/index.html
RUN mkdir -p /run/nginx

#sshdのインストールとログイン用ユーザーの作成
RUN apk add openssh
RUN adduser -D test
RUN echo "test:test" | chpasswd

#telegrafのインストール
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add telegraf@testing
RUN rc-update add telegraf default
RUN rc-status
RUN telegraf -sample-config -input-filter cpu:mem -output-filter influxdb > telegraf.conf
RUN sed -i -e 's/hostname = ""/hostname = "nginx"/g' /etc/telegraf.conf
RUN sed -i -e 's/# urls = \["http:\/\/127.0.0.1:8086"\]/urls = \["http:\/\/influxdb_test:8086"\]/g' /etc/telegraf.conf

#rcの設定
#RUN mkdir /run/openrc/
RUN touch /run/openrc/softlevel
RUN rc-update add nginx
RUN rc-update add sshd
RUN rc-status
#RUN rc-service nginx start

#RUN apk add supervisor
COPY ./srcs/supervisord.conf /etc/
#000
CMD /bin/sh
#001
CMD /usr/sbin/nginx -g 'daemon off;'
#002 / 003 stopしてstartするとsshdが止まっている
CMD /usr/bin/supervisord
#004 stopしてstartするとsshdが止まっている
CMD /etc/init.d/sshd start && /usr/sbin/nginx -g 'daemon off;' 
#005
COPY ./srcs/myapp.sh /myapp.sh
RUN /etc/init.d/sshd start
RUN /etc/init.d/sshd stop
CMD ["/bin/sh", "/myapp.sh"]

#テストコマンド
#docker build -t nginx:006 .
#docker run -d -p 8080:80 -p 443:443 -p 22000:22 --network wordpress-network --name nginx_test nginx:006
#wget -S --no-check-certificate http://127.0.0.1:8080/ -O -
#ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null test@127.0.0.1 -p 22000
