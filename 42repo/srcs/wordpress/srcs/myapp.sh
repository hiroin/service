#!/bin/sh
/bin/sh wp_init.sh
/usr/bin/telegraf -config /etc/telegraf.conf -config-directory /etc/telegraf.conf &
exec /usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf