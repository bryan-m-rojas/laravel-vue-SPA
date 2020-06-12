FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf

RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash curl openrc busybox-extras

ARG PHP_UPSTREAM_CONTAINER=app
ARG PHP_UPSTREAM_PORT=9000

# Set upstream conf and remove the default conf
RUN echo "upstream php-upstream { server ${PHP_UPSTREAM_CONTAINER}:${PHP_UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf \
    && rm /etc/nginx/conf.d/default.conf

CMD ["nginx"]

EXPOSE 80 443
