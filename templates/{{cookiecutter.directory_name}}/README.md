# Configurarion to run HAProxy + Let's Encrypt

# Steps
1. Build docker images. If you modify your web-app or any Dockerfile, do not forget to bump-up a version and rebuild the Docker image.
    ```bash
    # 1.
    cd lets-certbot
    ./build.sh
    # 2.
    cd ../lets-haproxy
    .build.sh
    # 3
    cd ../{{cookiecutter.application_name}}
    .build.sh
    ```
1. Deploy the configuration. Run [deploy.sh](./deploy.sh). It will: 
    1. Find latest Docker images for you app
    1. Stop [docker-compose.yaml](./docker-compose.yaml) containers.
    1. Remove old artifacts, e.g. haproxy-restart-cron
    1. Copy new artifacts, e.g. haproxy-restart-cron
    1. Start new containers by running [docker-compose.yaml](./docker-compose.yaml)
    ```bash
    ./deploy.sh
    ```
