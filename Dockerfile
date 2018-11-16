FROM ubuntu:xenial
MAINTAINER Marc Fournier <marc.fournier@camptocamp.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
 && apt-get -y upgrade \
 && apt-get -y --no-install-suggests --no-install-recommends install \
    software-properties-common \
 && add-apt-repository ppa:adiscon/v8-stable \
 && apt-get update \
 && apt-get -y --no-install-suggests --no-install-recommends install \
    rsyslog=8.39.0-0adiscon5xenial1 \
    rsyslog-elasticsearch \
    rsyslog-kafka \
    rsyslog-mmfields \
    rsyslog-mmjsonparse \
    rsyslog-mmkubernetes \
    rsyslog-omstdout \
    rsyslog-relp \
    less \
    netcat-openbsd \
    curl \
 && apt-get -y --purge --autoremove remove software-properties-common \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ADD ./rsyslog.conf /etc/rsyslog.conf

CMD mkdir -p /etc/rsyslog-confd

ADD ./cleanup-old-logs.sh /usr/local/bin/cleanup-old-logs.sh

COPY /docker-entrypoint.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/sbin/rsyslogd", "-n", "-f", "/etc/rsyslog.conf"]

