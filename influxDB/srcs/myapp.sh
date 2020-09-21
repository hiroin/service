#!/bin/sh
/usr/sbin/influxd -config /etc/influxdb.conf
/usr/bin/telegraf -config /etc/telegraf.conf -config-directory /etc/telegraf.conf
/usr/sbin/rsyslogd -i /run/rsyslog.pid -f /etc/rsyslog.conf
/usr/sbin/grafana-server --config=/etc/grafana.ini --homepath=/usr/share/grafana cfg:paths.data=/var/lib/grafana/data cfg:paths.provisioning=/var/lib/grafana/provisioning
tail -f /dev/null