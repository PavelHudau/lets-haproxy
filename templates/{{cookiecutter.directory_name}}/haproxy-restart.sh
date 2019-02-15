#!/bin/bash

set -e

docker_compose="sudo docker-compose"

# cd to the directory so that docker-compose.yaml can be found
cd /usr/local/etc/{{cookiecutter.application_name}}

## Send SIGHUP to gracefully reload haproxy.
## This may cause only minimum connections lost during peak hours.
# See https://hub.docker.com/_/haproxy/ for details
${docker_compose} kill -s SIGHUP lets-haproxy

## Not very graceful reload of haproxy as it stop and start the container
## This will cause more connections lost than the method above.
# ${docker_compose} stop lets-haproxy
# ${docker_compose} start lets-haproxy

# Print all rinning containers
${docker_compose} ps
