#!/bin/bash

# About set options https://www.tldp.org/LDP/abs/html/options.html
set -e

main() {
    # cron has a security policy to not work if there are lots of hard-links to its files.
    # Unfortunately Docker's layered file-system makes files have lots of hard-links.
    # Command below should fix a lot of hardlinks crated.
    # For details see:
    # https://unix.stackexchange.com/questions/453006/getting-cron-to-work-on-docker
    touch /etc/crontab /etc/cron.*/*
    
    # Create log directory and a file to be able to run tail
    mkdir -p /var/log
    touch /var/log/lets-certbot-cron.log
    
    # Start cron and reload configs
    service cron restart
    service cron reload

    exec "$@"
}

main "$@"