#!/bin/bash

## This script packages infra files in temp folder and deletes the rest
## Run from project root using ./utils/resetEnv.sh
## (DELETES PROJECT) 

## Bring down containers and remove all dangling contianers and images
./develop down && docker system prune -y

# Change ownership of storage and bootsrap/cache folders to allow deletion
sudo chown $(id -u):$(id -g) storage -R 
sudo chown $(id -u):$(id -g) bootstrap/cache -R 

##
DOCKER_INFRA_FOLDERS=(.c9/ docker/ utils/)
DOCKER_INFRA_FILES=(develop docker-compose.dev.yml docker-env-example initNewProject.sh rebuildLaunch.sh setupEnv.sh)

## Make a temp folder for all Docker Infrastructure files
mkdir docker-temp/ 

## Move all Docker Infrastructure folders into docker-temp folder
for folder in "${DOCKER_INFRA_FOLDERS[@]}"
do
   mv $folder docker-temp/
done

## Move all Docker Infrastructure files into docker-temp folder
for file in "${DOCKER_INFRA_FILES[@]}"
do
   mv $file docker-temp/
done

## Move docker-temp folder up one level to prevent deletion
mv docker-temp/ ..

# Delete contents of the environement directory
shopt -s dotglob; rm ../environment/* -R

## Move docker-temp folder back to environment 
mv ../docker-temp ../environment/

## Move docker infrastructure files from docker-temp folder to project root 
shopt -s dotglob; mv docker-temp/* . && rmdir docker-temp/
