FROM ubuntu:focal
MAINTAINER Marc Fournier <marc.fournier@camptocamp.com>

ARG CONFD_VERSION=0.16.0
ARG CONFD_SHA256=255d2559f3824dd64df059bdc533fd6b697c070db603c76aaf8d1d5e6b0cc334

ADD https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 /usr/local/bin/confd
RUN echo "${CONFD_SHA256}  /usr/local/bin/confd" | sha256sum -c -
RUN chmod 0755 /usr/local/bin/confd

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
 && apt-get -y upgrade \
 && apt-get -y --no-install-suggests --no-install-recommends install \
    software-properties-common \
 && add-apt-repository ppa:adiscon/v8-stable \
 && apt-get update \
 && apt-get -y --no-install-suggests --no-install-recommends install \
    rsyslog=8.2004.0-0adiscon12focal1 \
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
    ngrep \
    tcpdump \
    iputils-ping \
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
