### Dockerized version of Concrete CMS. Find out more about Concrete CMS at https://www.concretecms.com/

This image is a fork of https://github.com/Tomcat128/dockerized-concrete5 with the following bugfixes and enhancements:

- based on php:7.4.28-apache. The original is based on php:8.1.3-apache but this gives an undefined variable error when trying to use the market place
- timezone can now be configured by the environment variable TZ. The original had "Europe/Berlin" hardcoded
- in case you are running the image behind a reverse proxy, you assign a space separated list of trusted proxies to the environment variable TRUSTED_PROXIES

### Example usage

This is my configuration for using it behind the famous traefik reverse proxy.

Create an .env file with your configuration (don't forget to change passwords):

```
MYSQL_DATABASE=c5
MYSQL_USER=c5
MYSQL_PASSWORD=DuabohPhook7ohdait9Y
MYSQL_ROOT_PASSWORD=IjahQueur5oowae3ath2
TRUSTED_PROXIES=traefik
TZ=Europe/Berlin
```

And then the docker-compose.yml:

```yaml
version: '3'

services:
  concretecms:
    image: deburau/concrete-cms:9.0.2
    restart: always
    depends_on:
      - concretecms_db
    container_name: concretecms
    hostname: concretecms.flexoft.net
    environment:
      - TRUSTED_PROXIES=${TRUSTED_PROXIES}
      - TZ=${TZ}
    volumes:
      - ./concretecms/blocks:/srv/app/public/application/blocks
      - ./concretecms/packages:/srv/app/public/packages
      - ./concretecms/configuration:/srv/app/public/application/config
      - ./concretecms/files:/srv/app/public/application/files
      - ./concretecms/php_conf.d/timezone.ini:/usr/local/etc/php/conf.d/timezone.ini
    networks:
      concretecms:
      traefik:
      posteio:
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=traefik"
      - "traefik.http.routers.concretecms.rule=Host(`concretecms.example.com`)"
      - "traefik.http.routers.concretecms.entrypoints=websecure"
      - "traefik.http.routers.concretecms.tls=true"
      - "traefik.http.routers.concretecms.tls.domains[0].main=concretecms.example.com"
      - "traefik.http.routers.concretecms.service=concretecms"
      - "traefik.http.services.concretecms.loadbalancer.server.port=80"
      - "traefik.http.services.concretecms.loadbalancer.server.scheme=http"
      - "traefik.http.services.concretecms.loadbalancer.passhostheader=true"

  concretecms_db:
    image: mariadb:10
    networks:
      concretecms:
    environment:
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      TZ: ${TZ}
    container_name: concretecms_db
    volumes:
      - ./mysql:/var/lib/mysql

networks:
  concretecms:
  traefik:
    external: true
  posteio:
    external: true
```

Here

- the network name of my traefik reverse proxy is `traefik`, the hostname of the reverse proxy is `traefik` too.
- `posteio` is the network of my email server

### Links

[GitHub Project Page](https://github.com/deburau/dockerized-concrete5)

[Docker Hub](https://hub.docker.com/repository/docker/deburau/concrete-cms/general)

