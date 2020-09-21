FROM alpine:3.12

RUN apk update
RUN apk add vim
RUN apk add wget

#openrcのインストール
RUN apk add openrc 
RUN mkdir /run/openrc/
RUN touch /run/openrc/softlevel

#influxDBのインストール
RUN apk add influxdb

#telegrafのインストール
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add telegraf@testing
RUN rc-update add telegraf default
RUN rc-status
RUN telegraf -sample-config -input-filter cpu:mem -output-filter influxdb > telegraf.conf
RUN sed -i -e 's/hostname = ""/hostname = "grafana"/g' /etc/telegraf.conf
RUN sed -i -e 's/# urls = \["http:\/\/127.0.0.1:8086"\]/urls = \["http:\/\/influxdb_test:8086"\]/g' /etc/telegraf.conf
#RUN rc-service telegraf restart
#RUN /usr/bin/telegraf -config /etc/telegraf.conf -config-directory /etc/telegraf.conf

#grafanaのインストール
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add grafana@testing
RUn apk add sqlite
RUN rc-update add grafana default
RUN apk add rsyslog
RUN rc-update add rsyslog boot
RUN rc-status
RUN mkdir -p /var/lib/grafana/provisioning/dashboards
RUN mkdir -p /var/lib/grafana/provisioning/datasources
RUN mkdir -p /var/lib/grafana/provisioning/notifiers
#RUN rc-service rsyslog start
#RUN rc-service grafana start
#RUN /usr/sbin/rsyslogd -i /run/rsyslog.pid -f /etc/rsyslog.conf
#RUN /usr/sbin/grafana-server --config=/etc/grafana.ini --homepath=/usr/share/grafana/
#RUN /usr/sbin/grafana-server --config=/etc/grafana.ini --homepath=/usr/share/grafana cfg:paths.data=/var/lib/grafana/data cfg:paths.provisioning=/var/lib/grafana/provisioning &

#supervisorのインストール
RUN apk add supervisor

COPY ./srcs/provisioning/datasources/datasource.yaml /var/lib/grafana/provisioning/datasources/datasource.yaml
COPY ./srcs/provisioning/dashboards/dashboards.yaml /var/lib/grafana/provisioning/dashboards/dashboards.yaml
COPY ./srcs/provisioning/dashboards/inflexDB-1600601915355.json /var/lib/grafana/provisioning/dashboards/inflexdb.json
COPY ./srcs/provisioning/dashboards/grafana-1600649739149.json /var/lib/grafana/provisioning/dashboards/grafana.json

#サービスの起動
#CMD /usr/sbin/influxd -config /etc/influxdb.conf
#CMD /usr/bin/telegraf -config /etc/telegraf.conf -config-directory /etc/telegraf.conf.d
#CMD /bin/sh
COPY ./srcs/supervisord.conf /etc/
CMD /usr/bin/supervisord

#grafanaの設定
#http://localhost:8086

#テストコマンド
#docker build -t grafana:000 .
#docker run -it --name grafana_test -p 3000:3000 --network wordpress-network grafana:000 /bin/sh
#docker run -d  --name grafana_test -p 3000:3000 --network wordpress-network grafana:000
#docker ps
#docker exec -it influxdb_test sh
#docker container stop influxdb_test
#docker container rm influxdb_test

#inflexDB操作コマンド
#influx -precision rfc3339 -host influxdb_test
#> SHOW DATABASES
#> USE telegraf
#> SHOW MEASUREMENTS
#> SHOW FIELD KEYS
#> SELECT time, host, usage_idle FROM cpu WHERE cpu = 'cpu-total' ORDER BY time DESC LIMIT 5

#後処理
#docker container prune

#<none>のイメージを削除
#docker rmi $(docker images -f "dangling=true" -q)

#待受ポート確認
#netstat -lpn