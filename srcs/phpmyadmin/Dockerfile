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

RUN mv /var/www/localhost/htdocs/phpmyadmin/config.sample.inc.php /var/www/localhost/htdocs/phpmyadmin/config.inc.php
RUN sed -i -e 's/localhost/mysql_test/g' /var/www/localhost/htdocs/phpmyadmin/config.inc.php

#mysql-clientのインストール
RUN apk add mysql mysql-client

#telegrafのインストール
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add telegraf@testing
RUN rc-update add telegraf default
RUN rc-status
RUN telegraf -sample-config -input-filter cpu:mem -output-filter influxdb > telegraf.conf
RUN sed -i -e 's/hostname = ""/hostname = "phpmyadmin"/g' /etc/telegraf.conf
RUN sed -i -e 's/# urls = \["http:\/\/127.0.0.1:8086"\]/urls = \["http:\/\/influxdb_test:8086"\]/g' /etc/telegraf.conf

#サービスの起動
RUN apk add supervisor
COPY ./srcs/supervisord.conf /etc/
CMD /usr/bin/supervisord

#テストコマンド
#docker build -t phpmyadmin:000 .
#docker run -it --name phpmyadmin_test -p 5000:80 --network wordpress-network phpmyadmin:000 /bin/sh
#docker run -d  --name phpmyadmin_test -p 5000:80 --network wordpress-network phpmyadmin:000
#docker ps
#docker exec -it phpmyadmin_test sh
#docker container stop phpmyadmin_test
#docker container rm phpmyadmin_test

#後処理
#docker container prune

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