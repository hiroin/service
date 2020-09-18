#!/bin/sh
/bin/sh wp_init.sh
/usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf
tail -f /dev/null