#!/bin/bash

## Brings down contatiners
./develop down && docker system prune -yq

## Builds all the docker images from scratch
./develop build --no-cache 

## Launches containers
./develop up -d 