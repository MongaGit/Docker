#!/bin/sh

## Download Image ProjectZomboid
sudo docker pull lorthe/monga_projectzomboid:latest

## Delete container ProjectZomboid
sudo docker rm -f project-zomboid

## Amount container ProjectZomboid
sudo docker run -d -t -i -e SERVERNAME='project-zomboid' \
-p 27015:27015/tcp -p 16261:16261/udp -p 16262:16262/udp \
-e ADMINPASSWORD='Password' \
-e FORCEUPDATE='' \
-e MOD_IDS='2931602698,2931602698' \
-e WORKSHOP_IDS='2875848298,2849247394,2923439994,2859296947,2859296947,2859296947' \
--name project-zomboid lorthe/monga_projectzomboid



