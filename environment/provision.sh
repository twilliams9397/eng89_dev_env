!#/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nginx 
systemctl status nginx

# This is written inside the VM
