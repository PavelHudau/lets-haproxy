FROM haproxy:1.8

RUN apt-get update \
    # Install rsyslog so that HAProxy logs can be directed to a file or standard output
    && apt-get install -y rsyslog \
    && mkdir -p /etc/rsyslog.d \
    && touch /var/log/haproxy.log \
    # here's the catch: by creating a soft-link that 
    # links /var/log/haproxy.log to /dev/stdout whatever 
    # rsyslogd writes to the file will endup being
    # propagated to the standard output of the container
    && ln -sf /dev/stdout /var/log/haproxy.log

# Copy rsyslog configuration
COPY ./rsyslog.conf /etc/rsyslog.d/

# Override entrypoint
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# Copy HAProxy config file
COPY ./haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["-f", "/usr/local/etc/haproxy/haproxy.cfg"]