#!/bin/bash

set -e

# Seems like letsencrypt produces a sigle file certificate for domain and www.domain,
# therefore we do not need to process domain and www.domain files separately
domains=( {{cookiecutter.www_domain}} )
#domains=( {{cookiecutter.www_domain}} www.{{cookiecutter.www_domain}} )
web_service='haproxy'
http_01_port='54321'
letsencrypt_certificates="/etc/letsencrypt"
haproxy_cert_dir="/etc/haproxy/certs"
log_dir="/var/log"

exp_limit=30;

function get_cert_file() {
    local domain=$1
    local latest_certificate_folder=$(ls ${letsencrypt_certificates}/live/ | grep "^${domain}" | tail -1)
    local fullchain_pem=${letsencrypt_certificates}/live/${latest_certificate_folder}/fullchain.pem
    if [[ $domain != "" ]]; 
    then
        echo ${fullchain_pem}
    else
        echo "[ERROR] No Argument is passed to get_cert_file"
        exit 1
    fi
}

function get_key_file() {
    local domain=$1
    local latest_certificate_folder=$(ls ${letsencrypt_certificates}/live/ | grep "^${domain}" | tail -1)
    local privkey_pem=${letsencrypt_certificates}/live/${latest_certificate_folder}/privkey.pem
    if [[ $domain != "" ]]; 
    then
        echo "${privkey_pem}"
    else
        echo "[ERROR] No Argument is passed to get_key_file"
        exit 1
    fi
}

cert_file=$(get_cert_file ${domains[0]})
if [ ! -f $cert_file ]; then
    echo "[ERROR] certificate file not found for domain ${domains[0]}."
    exit 1;
fi

exp=$(date -d "`openssl x509 -in $cert_file -text -noout|grep "Not After"|cut -c 25-`" +%s)
datenow=$(date -d "now" +%s)
days_exp=$(echo \( $exp - $datenow \) / 86400 |bc)

echo "Checking expiration date for ${domains[0]}..."

if [ "$days_exp" -gt "$exp_limit" ] ; then
    echo "The certificate is up to date, no need for renewal ($days_exp days left)."
    exit 0;
else
    echo "The certificate for $domain is about to expire soon. Starting Let's Encrypt (HAProxy:$http_01_port) renewal script..."
    certbot certonly \
        --standalone \
        --non-interactive \
        --agree-tos \
        --preferred-challenge http-01 \
        --http-01-port $http_01_port \
        --domains ${domains[0]},www.${domains[0]} \
        --email paylikn@gmail.com \
        --logs-dir "${log_dir}/certbot"
        #--config-dir ${WORKDIR} \
        #--work-dir ${letsencrypt_certificates} \

    if [ $? -ne 0 ]; then
        echo "[ERROR] Certbot failed.HAProxy certificate is not updated."
        exit 2;
    fi

    # Create a folder if does not exist
    mkdir -p ${haproxy_cert_dir}
    # Allow to write
    chmod -R go+rwx ${haproxy_cert_dir}
    # For HAProxy you must combine fullchain.pem and privkey.pem into a single file.

    for d in "${domains[@]}"
    do
        fullchain_pem=$(get_cert_file ${d})
        privkey_pem=$(get_key_file ${d})
        if [[ -f "${fullchain_pem}" && -f "${privkey_pem}" ]] ;  then
            echo "Combining certificate for ${d} domain from ${latest_certificate_folder}"
            cat ${fullchain_pem} ${privkey_pem} > ${haproxy_cert_dir}/${d}.pem
        else
            echo "[ERROR] Unable to find ${fullchain_pem} or ${privkey_pem} or both of them" 
        fi
    done
    # Protect by allowing only to read
    chmod -R go-rwx ${haproxy_cert_dir}

    #echo "Reloading $web_service"
    #/usr/sbin/service $web_service reload

    echo "Renewal process finished for domain $domain"
    exit 0;
fi