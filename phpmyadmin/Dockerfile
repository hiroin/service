FROM alpine:3.12

RUN apk update
RUN apk add vim
RUN apk add wget

#openrcのインストール
RUN apk add openrc 
RUN mkdir /run/openrc/
RUN touch /run/openrc/softlevel

#nginxのインストール
RUN apk add nginx
COPY ./srcs/default.conf /etc/nginx/conf.d/default.conf
RUN echo 'index.html' > /var/www/localhost/htdocs/index.html
RUN mkdir -p /run/nginx
#RUN rc-service nginx start

#phpのインストール
RUN apk add php7-fpm
RUN apk add php7-mysqli php7-mbstring php7-json php7-session
RUN rc-update add php-fpm7
RUN rc-status
COPY ./srcs/index.php /var/www/localhost/htdocs/index.php
#RUN rc-service php-fpm7 start

#phpmyadminのインストール
RUN cd /tmp \
 && wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz \
 && tar xvf phpMyAdmin-5.0.2-all-languages.tar.gz \
 && mv phpMyAdmin-5.0.2-all-languages /var/www/localhost/htdocs/phpmyadmin

#mysqlのインストール
RUN apk add mysql mysql-client

#mysqlの初期化
RUN rc-update add mariadb
RUN rc-status
RUN /etc/init.d/mariadb setup

#mysqlのログ設定
COPY ./srcs/my.cnf /etc/my.cnf

RUN apk add sudo
RUN rc-service mariadb start && sudo -u mysql mysqladmin -u mysql password toor
#RUN rc-service mariadb restart
#CMD sudo -u mysql /usr/bin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib/mariadb/plugin --user=mysql --pid-file=/run/mysqld/mariad

#テストコマンド
#docker build -t mysql:000 .
#docker run -it --name mysql_test -p 33060:3306 -p 5000:80 mysql:000 /bin/sh
#docker run -d --name mysql_test -p 33060:3306 -p 5000:80 mysql:000
#docker container prune

#mysql -u root
#$ SELECT Host, User FROM mysql.user;
#mysql -P 33060 -u mysql -ptoor
#mysql -P 3306 -u mysql -ptoor

#wget -S --no-check-certificate http://127.0.0.1/ -O -
#wget -S --no-check-certificate http://127.0.0.1/index.php -O -
#wget -S --no-check-certificate http://127.0.0.1/phpmyadmin/ -O -
#wget -S --no-check-certificate http://127.0.0.1:5000/index.html -O -
#wget -S --no-check-certificate http://127.0.0.1:5000/index.php -O -
#wget -S --no-check-certificate http://127.0.0.1:5000/phpmyadmin/ -O -

#<none>のイメージを削除
#docker rmi $(docker images -f "dangling=true" -q)