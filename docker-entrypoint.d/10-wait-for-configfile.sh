#!/bin/sh -e

FILE="/etc/rsyslog-confd/rsyslog.conf"

while [ ! -f "${FILE}" ]; do
  echo "waiting for ${FILE}"
  sleep 1
done

