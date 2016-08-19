#!/bin/sh

set -e

test -n "$1"
DAYS="$1"
test "$DAYS" -gt "0" # sanity check

check_du () {
  percent="$(df -P /var/log/ | tail -n1  | awk '{ print $5 }' | sed 's/%//')"
  test "${percent}" -gt "0" || return 1 # sanity check
  echo "==> current disk usage: ${percent}%"
  test "${percent}" -gt "65" && return 0
}

while true; do
  echo "=> about to remove the following elements, which are older than ${DAYS} days old:"
  find /var/log -type f -mtime "+${DAYS}" -ls -delete
  find /var/log -mindepth 1 -empty -ls -delete
  echo "=> about to compress the following logfiles, which are older than 1 day:"
  find /var/log -type f -mtime "+0" -name "*.log" -ls -exec gzip -9 {} \;
  echo "=> about to check disk usage:"
  if check_du; then
    echo "==> above threshold (65%), triggering cleanup"
    for i in $(seq 0 "$DAYS" | tac); do
      if check_du; then
        echo "==> due to space constraints, removing the following elements, which are older than ${i} days old:"
        find /var/log -type f -mtime "+${i}" -ls -delete
      fi
    done
  fi
  echo "=> going back to sleep for one hour..."
  sleep 3600
done
