ARG NODE_VERSION 
FROM node:${NODE_VERSION}

RUN apt-get update \
    && apt-get -y install git \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*