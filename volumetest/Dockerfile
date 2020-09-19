FROM alpine:3.12

RUN apk update
RUN apk add vim

COPY ./srcs/datasource.yaml /tmp
COPY ./srcs/dashboards.yaml /tmp

CMD /bin/sh

# docker build -t volumetest:999 .
# docker run -it -v datavolume_tmp:/tmp volumetest:999 /bin/sh

# ls -l /tmp

# docker build -t volumetest:999 .
# 