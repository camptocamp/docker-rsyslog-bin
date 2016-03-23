FROM ubuntu:trusty
MAINTAINER Marc Fournier <marc.fournier@camptocamp.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
 && apt-get -y upgrade \
 && apt-get -y --no-install-suggests --no-install-recommends install \
    software-properties-common

RUN add-apt-repository ppa:adiscon/v8-stable

RUN apt-get update \
 && apt-get -y --no-install-suggests --no-install-recommends install \
    rsyslog \
    rsyslog-relp \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ADD ./rsyslog.conf /etc/rsyslog.conf

COPY /docker-entrypoint.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/sbin/rsyslogd", "-n", "-f", "/etc/rsyslog.conf"]

