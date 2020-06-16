#!/bin/bash

## Brings down contatiners
./develop down && docker system prune -a -f

## Check if the specified Docker network exists - if not, create
NETWORK_NAME=laravel-net
if [ -z $(docker network ls --filter name=^${NETWORK_NAME}$ --format="{{ .Name }}") ]; then 
    docker network create ${NETWORK_NAME};
    echo "Created ${NETWORK_NAME}"
else {  
    echo "${NETWORK_NAME} already exists."
}
fi

## Builds all the docker images from scratch
./develop build --no-cache 

## Launches containers
./develop up -d 