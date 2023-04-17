#!/bin/bash


# This script is only designed to work with Ubuntu 20.04 and later
# It follows the official docker installation guide.
# Documentation: https://docs.docker.com/engine/install/ubuntu/
source /etc/lsb-release

if [ "$DISTRIB_ID" != "Ubuntu" ]
  then echo "Not running on Ubuntu! Exiting"
  exit
fi

if [ $(id -u) -ne 0 ]
  then echo "Not running as root, use sudo or switch to root user"
  exit
fi

if command -v docker &> /dev/null
then
    echo "Docker found, exiting"
    exit
fi

./check-distro.sh

apt-get update
apt-get install \
  ca-certificates \
  curl \
  gnupg -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" |
  tee /etc/apt/sources.list.d/docker.list >/dev/null

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

usermod -aG docker $USER

newgrp docker

docker ps
