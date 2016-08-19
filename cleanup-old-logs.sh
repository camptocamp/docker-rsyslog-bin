#!/bin/sh

set -e

test -n "$1"
test "$1" -gt "0"

while true; do
  echo "=> about to remove the following elements, which are older than ${1} days old:"
  find /var/log -type f -mtime "+${1}" -ls -delete
  find /var/log -mindepth 1 -empty -ls -delete
  echo "=> about to compress the following logfiles, which are older than 1 day:"
  find /var/log -type f -mtime "+1" -name "*.log" -ls -exec gzip -9 {} \;
  echo "=> going back to sleep for one hour..."
  sleep 3600
done
