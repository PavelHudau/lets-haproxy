# lets-haproxy

A configuration you can use to run a web application and APIs behind [HAProxy](http://www.haproxy.org/) with [Let's Encrypt](https://letsencrypt.org/), featuring automatically renewed SSL certificates.

HAProxy, Let's Encrypt Certbot, and your application(s) all run as Docker containers managed by Docker Compose. This makes the configuration easily portable to any cloud environment. Most of the setup is automated—only a few manual steps are required.

![diagram](/docs/diagram.jpg)

## Application

To use this configuration, your application should meet the following criteria:

1. HTTPS is required for security.
2. You want to minimize vendor lock-in with cloud providers, allowing for easy migration.
3. You aim to minimize hosting costs (e.g., using just one virtual machine, such as an Amazon EC2 instance).
4. Your web app consists of one or more services (e.g., website + API services) that run behind a proxy with SSL.

## Advantages

1. HAProxy handles HTTPS, so your web application can use plain HTTP internally.
2. All components run as Docker images—no additional system dependencies to configure.
3. Deployment is done with Docker Compose—no need to manually configure ports, networks, or files.
4. Most steps are scripted, leaving minimal manual setup.

## Prerequisites

1. A `letsencrypt` folder containing initial certificates. Here's a [helpful article](https://hackernoon.com/easy-lets-encrypt-certificates-on-aws-79387767830b) on how to generate them. (It's also possible to do this using only the `lets-certbot` and `lets-haproxy` Docker images.)
2. [Docker](https://www.docker.com/)
3. [Docker Compose](https://docs.docker.com/compose/)

## Steps

1. Build and run the Cookiecutter Docker container. It will generate all the necessary scripts. Just follow the Cookiecutter prompts and you’ll have everything set up in seconds.

    ```bash
    # Build the Cookiecutter Docker image
    ./build.sh

    # Run the Cookiecutter container to generate lets-haproxy scripts
    ./run.sh
    ```
