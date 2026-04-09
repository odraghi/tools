FROM alpine:3

RUN apk update

RUN apk add mandoc man-pages

RUN apk add bash bash-doc
RUN apk add bash-completion

RUN adduser -h /home/alpine -s /bin/bash -D alpine -u 1000
RUN sed -i "s/\(^root:x.*\/bin\/\)sh$/\1bash/" /etc/passwd

RUN apk add curl curl-doc
RUN apk add bind-tools bind-doc
RUN apk add iproute2 iproute2-doc
RUN apk add tcpdump tcpdump-doc
RUN apk add iperf3
RUN apk add fio fio-doc
RUN apk add iftop iftop-doc
RUN apk add iotop iotop-doc
RUN apk add sysstat sysstat-doc

RUN rm -rf /var/cache/apk/*
