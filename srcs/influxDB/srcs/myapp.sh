#!/bin/sh
/usr/bin/telegraf -config /etc/telegraf.conf -config-directory /etc/telegraf.conf &
exec /usr/sbin/influxd -config /etc/influxdb.conf
