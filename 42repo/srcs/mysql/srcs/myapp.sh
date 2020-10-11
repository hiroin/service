#!/bin/sh
/bin/sh /mysql_init.sh
/usr/sbin/php-fpm7 --nodaemonize &
/usr/bin/telegraf -config /etc/telegraf.conf -config-directory /etc/telegraf.conf &
/usr/sbin/nginx -g 'daemon off;' &
exec /usr/bin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib/mariadb/plugin --user=mysql --log-error=/var/log/mysqld.log
tail -f /dev/null
