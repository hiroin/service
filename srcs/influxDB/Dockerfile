FROM alpine:3.12

RUN apk update
RUN apk add vim
RUN apk add wget

#openrcのインストール
RUN apk add openrc 
RUN mkdir /run/openrc/
RUN touch /run/openrc/softlevel

#telegrafのインストール
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add telegraf@testing
RUN rc-update add telegraf default
RUN rc-status
RUN telegraf -sample-config -input-filter cpu:mem -output-filter influxdb > telegraf.conf
RUN sed -i -e 's/hostname = ""/hostname = "influxDB"/g' /etc/telegraf.conf
RUN sed -i -e 's/# urls = \["http:\/\/127.0.0.1:8086"\]/urls = \["http:\/\/127.0.0.1:8086"\]/g' /etc/telegraf.conf
#RUN rc-service telegraf restart
#RUN /usr/bin/telegraf -config /etc/telegraf.conf -config-directory /etc/telegraf.conf

#influxDBのインストール
RUN apk add influxdb
RUN rc-update add influxdb default
RUN rc-status
#RUN rc-service influxdb restart
#RUN /usr/sbin/influxd -config /etc/influxdb.conf

# #grafanaのインストール
# RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
# RUN apk add grafana@testing
# RUn apk add sqlite
# RUN rc-update add grafana default
# RUN apk add rsyslog
# RUN rc-update add rsyslog boot
# RUN rc-status
# RUN mkdir -p /var/lib/grafana/provisioning/dashboards
# RUN mkdir -p /var/lib/grafana/provisioning/datasources
# RUN mkdir -p /var/lib/grafana/provisioning/notifiers
# #RUN rc-service rsyslog start
# #RUN rc-service grafana start
# #RUN /usr/sbin/rsyslogd -i /run/rsyslog.pid -f /etc/rsyslog.conf
# #RUN /usr/sbin/grafana-server --config=/etc/grafana.ini --homepath=/usr/share/grafana/
# #RUN /usr/sbin/grafana-server --config=/etc/grafana.ini --homepath=/usr/share/grafana cfg:paths.data=/var/lib/grafana/data cfg:paths.provisioning=/var/lib/grafana/provisioning &

# COPY ./srcs/datasource.yaml /var/lib/grafana/provisioning/datasources/datasource.yaml
# COPY ./srcs/dashboards.yaml /var/lib/grafana/provisioning/dashboards/dashboards.yaml
# COPY ./srcs/inflexdb.json /var/lib/grafana/provisioning/dashboards/inflexdb.json

#サービスの起動
#CMD /usr/sbin/influxd -config /etc/influxdb.conf
#CMD /usr/bin/telegraf -config /etc/telegraf.conf -config-directory /etc/telegraf.conf.d
CMD /bin/sh
COPY ./srcs/myapp.sh /myapp.sh
CMD /bin/sh /myapp.sh
#RUN apk add supervisor
#COPY ./srcs/supervisord.conf /etc/
#CMD /usr/bin/supervisord

#grafanaの設定
#http://localhost:8086

#inflexDB操作コマンド
#influx -precision rfc3339
#> SHOW DATABASES
#> USE telegraf
#> SHOW MEASUREMENTS
#> SHOW FIELD KEYS
#> SELECT time, cpu, host, usage_idle FROM cpu WHERE cpu = 'cpu-total' ORDER BY time DESC LIMIT 20

#サンプル
#> CREATE DATABASE mydb
#> SHOW DATABASES
#> USE mydb
# > INSERT cpu,host=serverA,region=us_west value=0.64
# > SELECT "host", "region", "value" FROM "cpu"
# > INSERT temperature,machine=unit42,type=assembly external=25,internal=37
# > SELECT * FROM "temperature"

#テストコマンド
#docker build -t influxdb:000 .
#docker run -it --name influxdb_test2 -p 8086:8086 -p 8088:8088 -p 3000:3000 -v datavolume_inflexdb:/var/lib/influxdb/ -v /home/user42/42/ft_services/influxDB/data:/var/lib/grafana/ --network wordpress-network influxdb:001 /bin/sh
#docker run -d  --name influxdb_test2 -p 8086:8086 -p 8088:8088 -p 3000:3000 -v datavolume_inflexdb:/var/lib/influxdb/ -v /home/user42/42/ft_services/influxDB/data:/var/lib/grafana/ --network wordpress-network influxdb:001
#docker run -it --name influxdb_test -p 8086:8086 -p 8088:8088 -v datavolume_inflexdb:/var/lib/influxdb/ --network wordpress-network influxdb:000 /bin/sh
#docker run -d  --name influxdb_test -p 8086:8086 -p 8088:8088 -v datavolume_inflexdb:/var/lib/influxdb/ --network wordpress-network influxdb:000
#docker ps
#docker exec -it influxdb_test sh
#docker container stop influxdb_test
#docker container rm influxdb_test

#後処理
#docker container prune

#ボリュームの操作
#docker volume create --name=datavolume_inflexdb
#docker volume ls
#docker volume rm datavolume_inflexdb

#<none>のイメージを削除
#docker rmi $(docker images -f "dangling=true" -q)

#待受ポート確認
#netstat -lpn