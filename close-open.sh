#/bin/bash

  monitorID=$(docker ps -aqf "name=cadvisor") # get the container ID of tha cadvisor
  docker stop $(docker ps -a |  awk '{print $1}' | sed "s/$monitorID//") 
