#!/bin/bash

set -e

#PYTHON="python3"

#$PYTHON ./generator/main.py

DOCKER="sudo docker"
CURRENT_DIR=$(pwd)

$DOCKER run -it --rm \
    -v $CURRENT_DIR:/tmp/me \
    cookiecutter:1.0 -o /tmp/me/output /tmp/me/templates
