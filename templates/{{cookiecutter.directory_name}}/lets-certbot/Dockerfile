FROM debian:stretch-slim

RUN apt-get update \
    # Install cron
    && apt-get install -y cron \
    # Install bc tool. Needed to check dates
    && apt-get install -y bc \
    # Install certbot to
    && echo 'deb http://ftp.debian.org/debian stretch-backports main' >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y certbot -t stretch-backports

## To DEBUG cron install rsyslog.
## While attached to the running container start rsyslog
## > service rsyslog restart
## and look for cron logs at file /var/log/system
# RUN apt-get update && apt-get install -y rsyslog

# Copy letsencrypt files and give execution permission
COPY le-renew-haproxy.sh /usr/local/etc/le-renew-haproxy.sh
RUN chmod +x /usr/local/etc/le-renew-haproxy.sh

# Add crontab file in the cron directory
COPY le-renew-cron /etc/cron.d/le-renew-cron

# Cron files must be 644, non writable
# See https://github.com/dokku/dokku-postgres/issues/93
RUN chmod 644 /etc/cron.d/le-renew-cron

# Copy entrypoint and gove execute permissions
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["tail", "-f", "/var/log/lets-certbot-cron.log"]