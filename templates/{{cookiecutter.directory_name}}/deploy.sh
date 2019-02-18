#!/bin/bash

set -e

docker="sudo docker"
docker_compose="sudo docker-compose"
docker_compose_file="/usr/local/etc/{{cookiecutter.application_name}}/docker-compose.yaml"
docker_images="./DockerImages"
latest_image_files=()

build_images_array() {
    latest_image_files+=($(ls ${docker_images}/ | grep "^{{cookiecutter.application_name}}" | tail -1))
    latest_image_files+=($(ls ${docker_images}/ | grep "^lets-certbot" | tail -1))
    latest_image_files+=($(ls ${docker_images}/ | grep "^lets-haproxy" | tail -1))
}

load_image_if_not_exists() {
    local image_name_and_tag=$1
    if [[ "$(${docker} images -q ${image_name_and_tag} 2> /dev/null)" == "" ]]; then
        echo "[INFO] Loading ${image_name_and_tag} image"
        # Load container too deploy
        ${docker} load < ${docker_images}/${image_name_and_tag}.tar
    else
        echo "[WARN] Image ${image_name_and_tag} already exists so not loading" 
    fi
}

try_stop_old_docker_compose() {
    if [ -f ${docker_compose_file} ]; then
        echo "[INFO] stopping docker-compose and removing stale containers"
        ${docker_compose} -f ${docker_compose_file} down  
    else
        echo "[WARN] can not stop docker-compose as ${docker_compose_file} file does not exist"
    fi
}

remove_old_deployed_files() {
    echo "[INFO] Removing old deployment files"
    rm -fv /etc/cron.d/haproxy-restart-cron
    rm -rfv /usr/local/etc/{{cookiecutter.application_name}}/
}

copy_new_deployment_files() {
    echo "[INFO] Copy new deployment files"

    # Create directpry for logs
    mkdir -p /tmp/logs/cron

    mkdir -p /usr/local/etc/{{cookiecutter.application_name}}/
    cp haproxy-restart-cron/haproxy-restart.sh /usr/local/etc/{{cookiecutter.application_name}}/haproxy-restart.sh
    chmod +x /usr/local/etc/{{cookiecutter.application_name}}/haproxy-restart.sh
    cp docker-compose.yaml ${docker_compose_file}

    cp haproxy-restart-cron/haproxy-restart-cron /etc/cron.d/haproxy-restart-cron
    # Cron files must be 644, non writable
    # See https://github.com/dokku/dokku-postgres/issues/93
    chmod 644 /etc/cron.d/haproxy-restart-cron
}

build_images_array
echo "[INFO] Load the following images: ${latest_image_files[@]}"

for image_file in "${latest_image_files[@]}"
do
    # Path container name without file extension .tar
    load_image_if_not_exists ${image_file%.tar}
done

try_stop_old_docker_compose
remove_old_deployed_files
copy_new_deployment_files

# Stop all images
#sudo docker-compose stop

## Remove current version of image
#sudo docker rmi ${old_image_name}

## Run after deployment
echo "[INFO] Stating docker-compose"
sudo ${docker_compose} -f ${docker_compose_file} up -d