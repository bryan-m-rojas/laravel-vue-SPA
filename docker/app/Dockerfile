ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm

## Environment Variables
ENV BASE_UTILS="locales apt-utils procps vim less"
ENV BASE_LIBS="sudo curl"
ENV PHP_EXTS="pdo_mysql"
ENV PECL_EXTS="redis"

## Install the BASE_UTILS 
RUN apt-get update \
    && apt-get install -y $BASE_UTILS \
    && locale-gen en_US.UTF-8

## Install the BASE_LIBS
RUN apt-get update \
    && apt-get install -y --no-install-recommends $BASE_LIBS \
    && rm -rf /var/lib/apt/lists/*

## Install the PHP extensions
RUN docker-php-ext-install $PHP_EXTS

## Install the Pecl extensions
RUN apt-get update -yqq \
    && pecl channel-update pecl.php.net \
    && pecl install $PECL_EXTS \
    && docker-php-ext-enable $PECL_EXTS \
    && pecl clear-cache

# Do some cleanup
RUN apt-get clean  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www/html

EXPOSE 9000