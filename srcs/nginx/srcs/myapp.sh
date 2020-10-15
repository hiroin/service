#!/bin/sh

/usr/bin/telegraf -config /etc/telegraf.conf -config-directory /etc/telegraf.conf &
/usr/sbin/nginx -g 'daemon off;' &
exec /usr/sbin/sshd -D