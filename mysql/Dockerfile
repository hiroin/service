FROM alpine:3.12

RUN apk update
RUN apk add openrc 
RUN apk add vim
RUN apk add emacs

#mysqlのインストール
RUN apk add mysql mysql-client

#mysqlの初期化
RUN mkdir /run/openrc/
RUN touch /run/openrc/softlevel
RUN rc-update add mariadb
RUN rc-status
RUN /etc/init.d/mariadb setup
#RUN /etc/init.d/mariadb start

#mysqlのログ設定
COPY ./srcs/my.cnf /etc/my.cnf

RUN apk add sudo
#RUN sudo -u mysql mysqladmin -u mysql password toor
#CMD sudo -u mysql /usr/bin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib/mariadb/plugin --user=mysql --pid-file=/run/mysqld/mariad
#テストコマンド
#docker build -t mysql:000 .
#docker run -it --name mysql_test -p 33060:3306 mysql:000 /bin/sh
#docker run -d --name mysql_test -p 33060:3306 mysql:000
#docker container prune

#mysql -u root
#$ SELECT Host, User FROM mysql.user;
#mysql -P 33060 -u mysql -ptoor