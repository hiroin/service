#!/bin/sh
/usr/bin/telegraf -config /etc/telegraf.conf -config-directory /etc/telegraf.conf &
exec /bin/sh vsftpd_start.sh