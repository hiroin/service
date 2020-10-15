#!/bin/sh
if [ ! -e "/var/lib/mysql/ib_buffer_pool" ];then
	/etc/init.d/mariadb setup
	rc-service mariadb start
	sudo -u mysql mysqladmin -u mysql password mysql
	mysql -e "GRANT ALL privileges ON *.* to mysql@'%' identified by 'mysql' with grant option;"
	mysql -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
	mysql -e "CREATE USER 'wordpress'@'%' identified by 'wordpress';"
	mysql -e "GRANT ALL ON wordpress.* TO 'wordpress'@'%';"	
	rc-service mariadb stop
fi
if [ ! -e "/run/mysqld" ];then
	mkdir /run/mysqld
fi
chown mysql /run/mysqld
