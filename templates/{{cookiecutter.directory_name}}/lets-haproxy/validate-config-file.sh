#!/bin/bash

# Validates HAProxy configuration file.
# See for details https://docs.docker.com/samples/library/haproxy/

sudo docker run -it \
    -v /home/pavel/Repositories/{{cookiecutter.application_name}}releases/lets-haproxy:/usr/local/etc/haproxy \
    -v /etc/haproxy/certs:/etc/haproxy/certs \
    -v /tmp/logs/haproxy:/dev/log \
    --rm --name syntax-check-haproxy haproxy:1.8 \
    haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg
