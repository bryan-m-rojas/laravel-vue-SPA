#!/bin/bash

## Run in a fresh Cloud9 Env to initialize a new Laravel Project + Dev Env
## (Only run this script the first time)

## The default C9 EBS Volume is 10GiB - resize to 20 GiB 
chmod 777 utils/resizeEBS.sh && ./utils/resizeEBS.sh 20

## Move Laravel-Docker-Cloud9 contents from folder to project root and delete folder
shopt -s dotglob; mv ../Laravel-Docker-Cloud9/* . && rmdir ../Laravel-Docker-Cloud9/

## Check if docker-compose is installed - if not, install
command_exists () {
    type "$1" &> /dev/null ;
}

if command_exists docker-compose ; then
  echo "docker-compose is already installed."
else {
  sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  echo "Installed docker-compose."
}
fi

## Check if the specified Docker network exists - if not, create
NETWORK_NAME=laravel-net
if [ -z $(docker network ls --filter name=^${NETWORK_NAME}$ --format="{{ .Name }}") ]; then 
    docker network create ${NETWORK_NAME};
    echo "Created ${NETWORK_NAME}"
else {  
    echo "${NETWORK_NAME} already exists."
}
fi

## Creates .env file from docker-env-example 
cp docker-env-example .env
echo "Created .env file from docker-env-example file."

## Adds Variable from .env file to Cloud9 Env
set -a && source .env && set +a

## Create a New Laravel Project in the laravel folder
chmod 777 ./develop && ./develop composer create-project --prefer-dist laravel/laravel laravel

## Brings down contatiners
./develop down 

## Checks if laravel .env file exists - if not, creates from laravel .env.example
LARAVEL_ENV_FILE=laravel/.env
if [ -f "$LARAVEL_ENV_FILE" ]; then
    echo "$LARAVEL_ENV_FILE already exists."
else 
    cp laravel/.env.example laravel/.env
    echo "Created $ENV_FILE from laravel/.env.example file."
fi

## Update Laravel .env file to set up proper MySQL connection - match values with MySQL container
DATABASE_HOST=mysql
DATABASE_PORT="$MYSQL_PORT"
DATABASE_DATABASE="$MYSQL_DATABASE"
DATABASE_USERNAME="$MYSQL_USER"
DATABASE_PASSWORD="$MYSQL_PASSWORD"

sed -i 's/DB_HOST=.*/DB_HOST='$DATABASE_HOST'/' $LARAVEL_ENV_FILE
sed -i 's/DB_PORT=.*/DB_PORT='$DATABASE_PORT'/' $LARAVEL_ENV_FILE
sed -i 's/DB_DATABASE=.*/DB_DATABASE='$DATABASE_DATABASE'/' $LARAVEL_ENV_FILE
sed -i 's/DB_USERNAME=.*/DB_USERNAME='$DATABASE_USERNAME'/' $LARAVEL_ENV_FILE
sed -i 's/DB_PASSWORD=.*/DB_PASSWORD='$DATABASE_PASSWORD'/' $LARAVEL_ENV_FILE

## Add Docker Env Variables to bottom of Laravel Env file to prepare for move
cat .env >> laravel/.env
echo "Added docker env variables to $LARAVEL_ENV_FILE file (Preparing for move)"

## Add docker project .gitignore to laravel .gitignore
cat .gitignore >> laravel/.gitignore
echo "Added docker .gitignore files to laravel .gitignore file (Preparing for move)"

## Copy existing .gitignore into docker.gitignore temp file
cp .gitignore docker.gitignore
echo "Created temp docker.gitignore file (Preparing for move)"

## Copy existing README into temp DOCKER_README file
cp README.md DOCKER_README
echo "Created temp Docker README file (Preparing for move)"

## Move Laravel project from laravel folder to project root and delete laravel folder
shopt -s dotglob; mv laravel/* . && rmdir laravel/

## Builds all the docker images from scratch
./develop build --no-cache 

## Launches containers
./develop up -d 

## Change Laravel Directory Permissions so that they are accesible by server
./develop exec app chown www-data:www-data storage -R 
./develop exec app chown www-data:www-data bootstrap/cache -R 

## Clean up Docker 
docker system prune -f