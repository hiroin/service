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
#RUN /etc/init.d/mariadb setup

#mysqlのログ設定
COPY ./srcs/my.cnf /etc/my.cnf
RUN touch /var/log/mysqld.log
RUN chmod 666 /var/log/mysqld.log
RUN touch /var/log/general.log
RUN chmod 666 /var/log/general.log

#mysqlの3306番ポートで待ち受ける設定変更
RUN sed -i -e 's/skip-networking/skip-networking = 0/g' /etc/my.cnf.d/mariadb-server.cnf

#mysqlのSQLによる設定
# mysqlユーザーにパスワードの設定
# wordpressユーザーの作成 / wordpressテーブルの作成
RUN apk add sudo
# RUN rc-service mariadb start \
#  && sudo -u mysql mysqladmin -u mysql password mysql \
#  && mysql -e "GRANT ALL privileges ON *.* to mysql@'%' identified by 'mysql' with grant option;" \
#  && mysql -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" \
#  && mysql -e "CREATE USER 'wordpress'@'%' identified by 'wordpress';" \
#  && mysql -e "GRANT ALL ON wordpress.* TO 'wordpress'@'%';"
#RUN rc-service mariadb restart

#telegrafのインストール
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add telegraf@testing
RUN rc-update add telegraf default
RUN rc-status
RUN telegraf -sample-config -input-filter cpu:mem -output-filter influxdb > telegraf.conf
RUN sed -i -e 's/hostname = ""/hostname = "mysql"/g' /etc/telegraf.conf
RUN sed -i -e 's/# urls = \["http:\/\/127.0.0.1:8086"\]/urls = \["http:\/\/influxdb_test:8086"\]/g' /etc/telegraf.conf

#サービスの起動
RUN apk add supervisor
COPY ./srcs/supervisord.conf /etc/
#CMD /usr/bin/supervisord
COPY ./srcs/myapp.sh /myapp.sh
COPY ./srcs/mysql_init.sh /mysql_init.sh
CMD /bin/sh /myapp.sh

#テストコマンド
#docker build -t mysql:000 .
#docker run -it --name mysql_test -p 33060:3306 -p 5000:80 -v datavolume:/var/lib/mysql --network wordpress-network mysql:000 /bin/sh
#docker run -d --name mysql_test -p 33060:3306 -p 5000:80 -v datavolume:/var/lib/mysql --network wordpress-network mysql:000
#docker run -d --name mysql_test -p 33060:3306 -p 5000:80 -v datavolume:/var/lib/mysql mysql:001
#docker ps
#docker exec -it mysql_test sh
#docker container stop mysql_test
#docker container rm mysql_test

#後処理
#docker container prune

#ボリュームの操作
#docker volume create --name=datavolume
#docker volume ls
#docker volume rm datavolume

#mysql -u root
#$ SELECT User, Host FROM mysql.user;
#mysql -h 127.0.0.1 -P 33060 -u mysql -pmysql
#mysql -h 127.0.0.1 -P 3306 -u mysql -pmysql

#wget -S --no-check-certificate http://127.0.0.1/ -O -
#wget -S --no-check-certificate http://127.0.0.1/index.php -O -
#wget -S --no-check-certificate http://127.0.0.1/phpmyadmin/ -O -
#wget -S --no-check-certificate http://127.0.0.1:5000/index.html -O -
#wget -S --no-check-certificate http://127.0.0.1:5000/index.php -O -
#wget -S --no-check-certificate http://127.0.0.1:5000/phpmyadmin/ -O -

#ブラウザによる動作確認
#http://127.0.0.1:5000/
#http://127.0.0.1:5000/phpmyadmin/server_databases.php?server=1

#<none>のイメージを削除
#docker rmi $(docker images -f "dangling=true" -q)

#待受ポート確認
#netstat -lpn