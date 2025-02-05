FROM php:7.4.28-apache

LABEL maintainer="concretecms@flexoft.net"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="concretecms"
LABEL org.label-schema.description="Docker image for the Concrete CMS based on https://github.com/tomcat128/dockerized-concrete5"
LABEL org.label-schema.url="https://www.concretecms.com/"
LABEL org.label-schema.vcs-url="https://github.com/deburau/dockerized-concrete5"
LABEL org.label-schema.vcs-ref="${VCS_REF}"
LABEL org.label-schema.vendor="PortlandLabs"
LABEL org.label-schema.version="${VERSION}"

ENV C5_VERSION 9.0.2
ENV C5_URL https://www.concretecms.org/download_file/3254ddbf-35f0-4c92-8ed1-1fb6b9c0f0d4
ENV C5_BASEDIR /srv/app/public

RUN mkdir -p "$C5_BASEDIR"

WORKDIR /srv/app/

ENV APACHE_DOCUMENT_ROOT "$C5_BASEDIR"

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN a2enmod rewrite
RUN a2enmod ssl

RUN apt-get update -y \
       && apt-get install -y libzip-dev \
       && apt-get install -y libfreetype6-dev \
       && apt-get install -y libmcrypt-dev \
       && apt-get install -y libjpeg-dev \
       && apt-get install -y libpng-dev \
       && apt-get install -y imagemagick imagemagick-doc \
       && apt-get install -y zlib1g-dev \
       && apt-get install -y wget \
       && apt-get install -y unzip

RUN docker-php-ext-configure \
       gd \
        --with-freetype \
        --with-jpeg

RUN docker-php-ext-install \
       pdo_mysql \
       zip \
       gd \
       calendar

RUN cd /usr/local/src \
    && wget --no-verbose $C5_URL -O concrete5.zip \
    && unzip -qq concrete5.zip -d concrete5 \
    && rm -rf "$C5_BASEDIR" \
    && mv "/usr/local/src/concrete5/concrete-cms-$C5_VERSION" "$C5_BASEDIR" \
    && rm -rf /usr/local/src/concrete5 /usr/local/src/concrete5.zip

RUN chown -R www-data:www-data /srv/app

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY root/ /

VOLUME /srv/app/public/application/blocks
VOLUME /srv/app/public/packages
VOLUME /srv/app/public/application/config
VOLUME /srv/app/public/application/files

CMD ["/docker-init.sh"]
