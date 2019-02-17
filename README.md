# lets-haproxy
Configuration which you can use to run a web-application + APIs behind [HAProxy](http://www.haproxy.org/) with [Let's Encrypt](https://letsencrypt.org/) and automatically refreshed SSL certificates.

## Application
You need to deploy an App available on the web and your criterial are:
1. HTTPS for security.
1. Minimize vendor lock on cloud providers, so you can easily move to other cloud.
1. Minimize hosting cost, e.g. have just 1 Virtual Machine (e.g. Amazon EC2).
1. Have 1 or more pieces of your web-app (e.g. website +  APIs service(s))

## Advantages:
1. HAProxy takes care about HTTPS part. Your web-application can be just talk plain HTTP.
1. All components are Docker images, so no other dependencies you need to configure.
1. Deployment is done with docker-compose, so no need to configure ports / networks / files.
1. All steps are scripted. There are minimum manul things to do.

## Pre-requisites:
1. letsencrypt folder with initial certificates
1. [Docker](https://www.docker.com/)
1. [Docker Compose](https://docs.docker.com/compose/)

## Steps:
1. Build docker images
1. Run docker-compose