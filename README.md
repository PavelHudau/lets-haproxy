# lets-haproxy
A configuration which you can use to run a web-application + APIs behind [HAProxy](http://www.haproxy.org/) with [Let's Encrypt](https://letsencrypt.org/) and automatically renewed SSL certificates.

HAProxy, Let's Encrypt certbot and your Application(s) are run as Docker containers with Docker Compose. Therefore entire configuration is easy portable to any cloud. Almost everything is automated, so there are just a few manual steps you need to make.

![diagram](/docs/diagram.jpg)

## Application
You need to deploy an App available on the web and your criterial are:
1. HTTPS for security.
1. Minimize vendor lock on cloud providers, so you can easily move to other cloud.
1. Minimize hosting cost, e.g. have just 1 Virtual Machine (e.g. Amazon EC2).
1. Have 1 or more pieces of your web-app (e.g. website +  APIs service(s)) running behind a proxy with SSL.

## Advantages:
1. HAProxy takes care about HTTPS part. Your web-application can just talk plain HTTP.
1. All components are Docker images, so thereare no other dependencies to configure.
1. Deployment is done with docker-compose, so no need to configure ports / networks / files.
1. All steps are scripted. There are minimum manul things left to do.

## Pre-requisites:
1. letsencrypt folder with initial certificates. Here is a [nice article](https://hackernoon.com/easy-lets-encrypt-certificates-on-aws-79387767830b) which shows how to get it. (It's also possible to do with just lets-certbot and lets-haproxy Docker images)
1. [Docker](https://www.docker.com/)
1. [Docker Compose](https://docs.docker.com/compose/)

## Steps:
1. build and run cookiecutter. cookiecutter will generate your scripts. Follow cookiecutter instruction and you will get all scripts in seconds.
    ```bash
    # Builds cookiecutter docker image
    ./build.sh
    # Run cookiecutter docker container to generate lets-haproxy scripts
    ./run.sh
    ```
1. Go to newly generated scripts folder `output`. The folder contains all scripts you would need to run and a sample react app.
    ```bash
    cd output\{{directory_name you provided to cookiecutter}}
    ``` 
    let-haproxy documentation / instructions can be found at `output\{{directory_name you provided to cookiecutter}}\README`
