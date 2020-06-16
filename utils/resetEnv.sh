#!/bin/bash

## This script packages infra files in temp folder and deletes the rest
## Run from project root using ./utils/resetEnv.sh
## (DELETES PROJECT) 

## Bring down containers and remove all dangling contianers and images
./develop down && docker system prune -a -f

# Change ownership of storage and bootsrap/cache folders to allow deletion
sudo chown $(id -u):$(id -g) storage -R 
sudo chown $(id -u):$(id -g) bootstrap/cache -R 

##
DOCKER_INFRA_FOLDERS=(.git/ docker/ utils/)
DOCKER_INFRA_FILES=(develop docker-compose.dev.yml docker-env-example DOCKER_README docker.gitignore initNewProject.sh rebuildLaunch.sh setupEnv.sh)

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

# Delete contents of the Laravel-Docker-Cloud9 directory
shopt -s dotglob; sudo rm ../Laravel-Docker-Cloud9/* -R

## Move docker-temp folder back to Laravel-Docker-Cloud9 directory
mv ../docker-temp ../Laravel-Docker-Cloud9/

## Move docker infrastructure files from docker-temp folder to project root 
shopt -s dotglob; mv docker-temp/* . && rmdir docker-temp/

## Reset files for Laravel-Docker-Cloud 9 Infrastructure Project 
cp docker.gitignore .gitignore && rm docker.gitignore
cp DOCKER_README README.md && rm DOCKER_README