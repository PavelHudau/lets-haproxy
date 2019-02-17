#!/bin/bash
image_name={{cookiecutter.application_name}}
image_name_full_name=${image_name}:1.0.0

# 1. Build docker image
echo "Building Docker image"
sudo docker build -t $image_name_full_name .

# 2. Save docker image as tar, like: docker save mynewimage > /tmp/mynewimage.tar
sudo docker save ${image_name} > /tmp/${image_name_full_name}.tar

# 3. Copy to local folder
sudo cp /tmp/${image_name_full_name}.tar ../DockerImages/${image_name_full_name}.tar

# 4. Load container too deploy
#sudo docker load < ./DockerImages/${new_image_name}.tar

# TO RUN
# sudo docker run --rm -p 80:80 {{cookiecutter.application_name}}:1.0.0
