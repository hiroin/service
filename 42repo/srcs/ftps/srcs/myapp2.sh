#!/bin/sh
/usr/bin/telegraf -config /etc/telegraf.conf -config-directory /etc/telegraf.conf &
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
tail -f /dev/null
