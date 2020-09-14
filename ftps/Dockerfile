FROM alpine:3.12

RUN apk update
RUN apk add openssl
RUN apk add vsftpd
#デーモン管理ソフトのインストール
RUN apk add openrc 
RUN apk add vim

RUN mkdir /etc/vsftpd/ssl \
 && openssl genrsa -out /etc/vsftpd/ssl/server.key 2048 \
 && openssl req -new -key /etc/vsftpd/ssl/server.key -out /etc/vsftpd/ssl/server.csr -subj "/C=JP/ST=Tokyo/L=/O=/OU=/CN=localhost" \
 && openssl x509 -days 3650 -req -signkey /etc/vsftpd/ssl/server.key -in /etc/vsftpd/ssl/server.csr -out /etc/vsftpd/ssl/server.crt

RUN adduser -D test
RUN echo "test:test" | chpasswd
COPY ./srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN mkdir /run/openrc/
RUN touch /run/openrc/softlevel
RUN rc-update add vsftpd
RUN rc-status
#RUN rc-service vsftpd start

#ftpクライアントのインストール
RUN apk add lftp
COPY ./srcs/.lftprc /root/.lftprc

EXPOSE 21 60000 60001

RUN apk add supervisor
RUN mkdir /etc/supervisor.d
#COPY ./srcs/ftps.ini /etc/supervisor.d/ftps.ini
COPY ./srcs/ftps.ini /etc/supervisord.conf
COPY ./srcs/myapp.sh /myapp.sh
COPY ./srcs/myapp2.sh /myapp2.sh

#001
CMD ["/bin/sh"]
#002 起動し続けることが出来ない
#CMD ["rc-service", "vsftpd", "start"]
#003 コンテナをstopし、startすると、vsftpdが起動していない。また、SSL接続がでてないことがある。
#CMD ["/bin/sh", "/myapp.sh"]
#004 コンテナをstopし、startすると、vsftpdが起動していない。また、SSL接続がでてないことがある。
#CMD ["/usr/bin/supervisord"]
#005 1度だけftpできるが、1回接続が終わると、コンテナが終了してしまう
#CMD ["/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf"]
#006 
#CMD ["/bin/sh", "/myapp2.sh"]
#007 
CMD ["/usr/bin/supervisord"]

