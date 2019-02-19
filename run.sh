#!/bin/bash

set -e

DOCKER="sudo docker"
CURRENT_DIR=$(pwd)

$DOCKER run -it --rm \
    -v $CURRENT_DIR:/tmp/me \
    cookiecutter:1.0 -o /tmp/me/output /tmp/me/templates

# Fix files and folders ownership
sudo chown -R $USER:$USER ./output


# Below code is just for the reference

## Fix directories permissions
# sudo find output/ -type d -exec chmod 755 {} \;

## Make all files read-able
# sudo find output/ -type f -exec chmod 644 {} \;