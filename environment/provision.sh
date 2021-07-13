#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nginx -y
# systemctl status nginx

# This is written inside the VM

# added lines to automate nodejs install automation
# installs v6

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - 
sudo apt-get install -y nodejs

# install pm2 package manager
npm install pm2 -g 

sudo apt-get install python-software-properties -y