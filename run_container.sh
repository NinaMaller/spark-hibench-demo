#!/bin/bash

prinf "generating base image..."
$pwd/generate-base-image/scripts/build_docker.sh

printf "\nbuild demo image..."
docker build -t docker-hibench-demo /home/debug-hibench/docker-hibench-demo

#run the container
printf "\nRunning the container\n"
docker run -it --rm docker-hibench-demo
