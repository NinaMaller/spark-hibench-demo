#!/bin/bash

printf "generating base image..."
./generate-base-image/scripts/build_docker.sh

printf "\nbuild demo image..."
docker build -t docker-hibench-demo ./docker-hibench-demo

#run the container
printf "\nRunning the container\n"
docker run -it --rm docker-hibench-demo
#gotty-dir/gotty --config gotty-dir/gotty.cfg --max-connection 10 docker run --net isolated_nw -it --rm docker-hibench-demo &> /dev/null &

