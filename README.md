docker-ot-ui-apps
=================

Dockerfile for Open Targets Platform web applications

[![CI to Docker Hub](https://github.com/dceoy/docker-ot-ui-apps/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/dceoy/docker-ot-ui-apps/actions/workflows/docker-publish.yml)

Docker image
------------

Pull the image from [Docker Hub](https://hub.docker.com/r/dceoy/ot-ui-apps/)

```sh
$ docker image pull dceoy/ot-ui-apps
```

Usage
-----

Run a web server to serve the current directory at `/` of Nginx

```sh
$ docker container run --rm -p 80:80 -v ${PWD}:/var/lib/nginx/html:ro dceoy/ot-ui-apps
```

Run a web server with docker-compose

```sh
$ docker-compose -f /path/to/docker-ot-ui-apps/docker-compose.yml up
```
