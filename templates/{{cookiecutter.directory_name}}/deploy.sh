#!/bin/bash

set -e

docker="docker"
docker_compose="docker-compose"
docker_compose_file="/usr/local/etc/{{cookiecutter.application_name}}/docker-compose.yaml"
docker_images="./DockerImages"
latest_image_files=()

letsencrypt_dir="{{cookiecutter.letsencrypt_folder_full_path}}"
domains=( {{cookiecutter.www_domain}} )
haproxy_cert_dir="/etc/haproxy/certs"


create_ha_proxy_certificate_if_not_exist() {
    # Create a folder if does not exist
    mkdir -p ${haproxy_cert_dir}
    # Allow to write
    chmod -R go+rwx ${haproxy_cert_dir}
    # For HAProxy you must combine fullchain.pem and privkey.pem into a single file.

    for d in "${domains[@]}"
    do
        certificate_file=${haproxy_cert_dir}/${d}.pem
        if [[ -f "${certificate_file}" ]] ; then
            echo "[INFO] Certificate file ${certificate_file} already exists, no need to create it from Let's Encrypt folder"
        else
            latest_certificate_folder=$(ls ${letsencrypt_dir}/live/ | grep "^${d}" | tail -1)
            if [ -z "${latest_certificate_folder}" ] ; then
                echo "[ERROR] Unable to find ${letsencrypt_dir}/live/${d}. Make sure the path to letsencrypt folder is correct and the domain ${d} spelled correctly."
                exit 1
            fi

            fullchain_pem=${letsencrypt_dir}/live/${latest_certificate_folder}/fullchain.pem
            privkey_pem=${letsencrypt_dir}/live/${latest_certificate_folder}/privkey.pem
            if [[ -f "${fullchain_pem}" && -f "${privkey_pem}" ]] ; then
                echo "[INFO] Combining certificate for ${d} domain from ${latest_certificate_folder}"
                cat ${fullchain_pem} ${privkey_pem} > ${certificate_file}
            else
                echo "[ERROR] Unable to find ${fullchain_pem} or ${privkey_pem} or both of them"
                exit 1
            fi
        fi
    done

    # Protect by allowing only to read
    chmod -R go-rwx ${haproxy_cert_dir}
}

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

if [ ! -d ${letsencrypt_dir}/live ] ; then
    echo "[ERROR] Unable to find ${letsencrypt_dir}/live. Make sure the path to letsencrypt folder is correct."
    exit 1
fi

# First create HAProxy certificates from Let's Encrypt folder
create_ha_proxy_certificate_if_not_exist

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
#${docker_compose} stop

## Remove current version of image
#${docker} rmi ${old_image_name}

## Run after deployment
echo "[INFO] Stating docker-compose"
${docker_compose} -f ${docker_compose_file} up -d
