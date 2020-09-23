#!/bin/sh
/usr/sbin/sshd
/usr/bin/telegraf -config /etc/telegraf.conf -config-directory /etc/telegraf.conf &
/usr/sbin/nginx -g 'daemon off;' 
tail -f /dev/null
