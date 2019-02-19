#!/bin/sh

# About set options https://www.tldp.org/LDP/abs/html/options.html
set -o errexit
set -o nounset

readonly RSYSLOG_PID="/var/run/rsyslogd.pid"

main() {
  start_rsyslogd
  start_lb "$@"
}

start_rsyslogd() {
  rm -f $RSYSLOG_PID
  rsyslogd
}

start_lb() {
  # Add a couple useful flags
  # -W  -- "master-worker mode" (similar to the old "haproxy-systemd-wrapper"; allows for reload via "SIGUSR2")
  # -db -- disables background mode
  exec haproxy -W -db "$@"
}

main "$@"
