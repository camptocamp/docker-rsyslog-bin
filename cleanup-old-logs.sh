#!/bin/sh

set -e

test -n "$1"
test "$1" -gt "0"

while true; do
  echo "=> about to remove the following elements, which are older than ${1} days old:"
  find /var/log -type f -mtime "+${1}" -ls -delete
  find /var/log -empty -ls -delete
  echo "=> going back to sleep for one hour..."
  sleep 3600
done
