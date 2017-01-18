#!/usr/bin/env bash
set -e
set -x # Uncomment to debug


echo "deb https://download.gocd.io /" | sudo tee /etc/apt/sources.list.d/gocd.list
curl https://download.gocd.io/GOCD-GPG-KEY.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install openjdk-8-jdk
sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
sudo apt-get install -y go-server

sudo /etc/init.d/go-server start
