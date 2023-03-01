#!/bin/bash
#sudo yum update -y

echo "Init Terraform"
sudo apt update && \ 
sudo apt install -y docker.io \ 
sudo apt update \
sudo docker pull lorthe/monga_projectzomboid:latest \

## Run Docker ProjectZomboid
sudo docker push lorthe/projectzomboidserver:latest
sudo docker rm -f projectzomboid

sudo docker run -d -t -i -e SERVERNAME='MONGA_PZServer' \
-p 27015:27015/tcp -p 16261:16261/udp -p 16262:16262/udp \
-e ADMINPASSWORD='Password@123' \
-e FORCEUPDATE='' \
-e MOD_IDS='2931602698,2931602698' \
-e WORKSHOP_IDS='2875848298,2849247394,2923439994,2859296947,2859296947,2859296947' \
--name projectzomboid lorthe/monga_projectzomboid



