FROM alpine:3.12

RUN apk update
RUN apk add vim
RUN apk add wget

#openrcのインストール
RUN apk add openrc 
RUN mkdir /run/openrc/
RUN touch /run/openrc/softlevel

#mysqlクライアントのインストール
RUN apk add mysql-client

#wordpressのインストール
#https://wiki.alpinelinux.org/wiki/WordPress
RUN apk add lighttpd php7-common php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom
RUN sed -i -e 's/#   include "mod_fastcgi.conf"/   include "mod_fastcgi.conf"/g' /etc/lighttpd/lighttpd.conf
RUN sed -i -e 's/\/usr\/bin\/php-cgi/\/usr\/bin\/php-cgi7/g' /etc/lighttpd/mod_fastcgi.conf
#RUN rc-service lighttpd start && rc-update add lighttpd default
RUN rc-update add lighttpd default
RUN rc-status
RUN apk add php7-mysqli php7-zlib
RUN /etc/init.d/lighttpd restart
#wordpressのファイル設置
RUN mkdir -p /usr/share/webapps/
RUN cd /usr/share/webapps/ && wget http://wordpress.org/latest.tar.gz && tar -xzvf latest.tar.gz && rm latest.tar.gz
RUN chown -R lighttpd /usr/share/webapps/
RUN ln -s /usr/share/webapps/wordpress/ /var/www/localhost/htdocs/wordpress
RUN apk add php php7-phar curl
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
# wpコマンドはMySQLコンテナが動いていないと動かないので、一旦、CMDのmyapp.shのwp_init.shで実行
# RUN wp core install --url=http://127.0.0.1:5050/wordpress/ --title=test --admin_user=admin --admin_password=admin --admin_email=admin@example.com  --allow-root --path=/usr/share/webapps/wordpress/
# RUN wp language core activate ja --allow-root --path=/usr/share/webapps/wordpress/
# RUN wp user create bob bob@example.com --role=editor --user_pass=bob --allow-root --path=/usr/share/webapps/wordpress/
# RUN wp user create alice alice@example.com --role=author --user_pass=alice --allow-root --path=/usr/share/webapps/wordpress/
#RUN /etc/init.d/lighttpd restart

#動作確認用ファイル設置
RUN echo 'index.html' > /var/www/localhost/htdocs/index.html
COPY ./srcs/index.php /var/www/localhost/htdocs/index.php

#wordpress設定ファイル設置
COPY ./srcs/wp-config.php /usr/share/webapps/wordpress/wp-config.php

#wordpress初期設定スクリプト設置と実行
COPY ./srcs/wp_init.sh /wp_init.sh

#サービスの起動
COPY ./srcs/myapp.sh /myapp.sh
CMD /bin/sh /myapp.sh
#CMD /bin/sh

#テストコマンド(mysqlコンテナ関連)
#docker run -d --name mysql_test --network wordpress-network -p 33060:3306 -p 5000:80 -v datavolume:/var/lib/mysql mysql:003
#docker ps
#docker exec -it mysql_test3 sh
#docker container stop mysql_test3
#docker container rm mysql_test3

#テストコマンド(mysqlにwordpressのDBを作成する)
#DROP DATABASE wordpress ;
#mysql -P 33060 -h 127.0.0.1 -u mysql -pmysql
#CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;

#テストコマンド
#docker build -t wordpress:001 .
#docker run -it --name wordpress_test --network wordpress-network -p 5050:80 wordpress:001 /bin/sh
#docker run -d --name wordpress_test --network wordpress-network -p 5050:80 wordpress:001
#docker ps
#docker exec -it wordpress_test sh
#docker container stop wordpress_test
#docker container rm wordpress_test

#ネットワークの作成
#docker network ls
#docker network create wordpress-network
#docker network ls

#後処理
#docker container prune

#mysqlへの接続確認
#mysql -h mysql_test -P 3306 -u mysql -pmysql

#nginxへの接続確認(自コンテナのnginx向け)
#wget -S --no-check-certificate http://127.0.0.1/ -O -

#nginxへの接続確認(mysqlコンテナのnginx向け)
#wget -S --no-check-certificate http://mysql_test/phpmyadmin/ -O -

#nginxへの接続確認(ホスト)
#wget -S --no-check-certificate http://127.0.0.1:5050/index.html -O -
#wget -S --no-check-certificate http://127.0.0.1:5050/index.php -O -

#ブラウザによる動作確認
#http://127.0.0.1:5000/
#http://127.0.0.1:5000/phpmyadmin/server_databases.php?server=1

#<none>のイメージを削除
#docker rmi $(docker images -f "dangling=true" -q)

#待受ポート確認
#netstat -lpn