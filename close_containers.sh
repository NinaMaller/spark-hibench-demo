#!/bin/bash
while true
do
  monitorID=$(docker ps -aqf "name=cadvisor") # get the container ID of tha cadvisor
  docker stop $(docker ps -a | grep "hour" | awk '{print $1}' | sed "s/$monitorID//") >  /dev/null 2>/dev/null #delete everything that is not cadvisor
#  docker stop $(docker ps -a | grep "31 minute" | awk '{print $1}') >  /dev/null 2>/dev/null
#  docker stop $(docker ps -a | grep "32 minute" | awk '{print $1}') >  /dev/null 2>/dev/null
#  docker rm $(docker ps -a | grep "hour" | awk '{print $1}') > /dev/null 2>/dev/null
  sleep 300
done

