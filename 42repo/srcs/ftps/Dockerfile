FROM alpine:3.12

RUN apk update
RUN apk add openssl
RUN apk add vsftpd
#デーモン管理ソフトのインストール
RUN apk add openrc 
RUN apk add vim

RUN mkdir /etc/vsftpd/ssl \
 && openssl genrsa -out /etc/vsftpd/ssl/server.key 2048 \
 && openssl req -new -key /etc/vsftpd/ssl/server.key -out /etc/vsftpd/ssl/server.csr -subj "/C=JP/ST=Tokyo/L=/O=/OU=/CN=ftps-service" \
 && openssl x509 -days 3650 -req -signkey /etc/vsftpd/ssl/server.key -in /etc/vsftpd/ssl/server.csr -out /etc/vsftpd/ssl/server.crt

RUN adduser -D test
RUN echo "test:test" | chpasswd
COPY ./srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN mkdir /run/openrc/
RUN touch /run/openrc/softlevel
RUN rc-update add vsftpd
RUN rc-status
#RUN rc-service vsftpd start

#telegrafのインストール
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add telegraf@testing
RUN rc-update add telegraf default
RUN rc-status
RUN telegraf -sample-config -input-filter cpu:mem -output-filter influxdb > telegraf.conf
RUN sed -i -e 's/hostname = ""/hostname = "ftps"/g' /etc/telegraf.conf
RUN sed -i -e 's/# urls = \["http:\/\/127.0.0.1:8086"\]/urls = \["http:\/\/influxdb-service:8086"\]/g' /etc/telegraf.conf

#ftpクライアントのインストール
RUN apk add lftp
COPY ./srcs/.lftprc /root/.lftprc

EXPOSE 21 60000 60001

#RUN apk add supervisor
#RUN mkdir /etc/supervisor.d
#COPY ./srcs/ftps.ini /etc/supervisord.conf
#COPY ./srcs/myapp.sh /myapp.sh
#COPY ./srcs/myapp2.sh /myapp2.sh
COPY ./srcs/vsftpd_start.sh /vsftpd_start.sh
COPY ./srcs/myapp3.sh /myapp3.sh

#001
#CMD ["/bin/sh"]
#002 起動し続けることが出来ない
#CMD ["rc-service", "vsftpd", "start"]
#003 コンテナをstopし、startすると、vsftpdが起動していない。また、SSL接続ができないことがある。
#CMD ["/bin/sh", "/myapp.sh"]
#004 コンテナをstopし、startすると、vsftpdが起動していない。また、SSL接続ができないことがある。
#CMD ["/usr/bin/supervisord"]
#005 1度だけftpできるが、1回接続が終わると、コンテナが終了してしまう
#CMD ["/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf"]
#006 
#CMD ["/bin/sh", "/myapp2.sh"]
#007 
#CMD ["/usr/bin/supervisord"]
#008 起動し続けることが出来ない
#CMD ["/etc/init.d/vsftpd", "start"]
#009 
CMD ["/bin/sh", "/myapp3.sh"]

#コンテナ起動コマンド
#docker build -t vsftpd:000 .
#docker run --name ftps_test -d -p 21:21 -p 60000-60001:60000-60001 --network wordpress-network vsftpd:000

#試験コマンド
#vim ~/.lftprc
#set ssl:verify-certificate no
#lftp -d -u test 127.0.0.1
#ls
#!ls
#put Dockerfile
#get Dockerfile
#openssl s_client -connect localhost:21 -starttls ftp

