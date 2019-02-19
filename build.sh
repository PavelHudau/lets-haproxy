#!/bin/bash

set -e

DOCKER="sudo docker"

$DOCKER build -f ./cookiecutter/.Dockerfile -t cookiecutter:1.0 ./cookiecutter

# TO test cookiecutter image:
#sudo docker run -it --rm --entrypoint "/bin/sh" -v $(pwd):/tmp/me cookiecutter:1.0
