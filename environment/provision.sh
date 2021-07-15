#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nginx -y
# systemctl status nginx

# added lines to automate nodejs install automation
# installs v6

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - 
sudo apt-get install -y nodejs 

# install pm2 package manager
npm install pm2 -g 

sudo apt-get install python-software-properties -y # installs any missing python properties

sudo echo "export DB_HOST:mongodb://192.168.10.150:27017/posts" >> ~/.bashrc # sets environment variable to bashrc file
source ~/.bashrc

sudo rm -rf /etc/nginx/sites-available/default # reverse proxy setup so port 3000 isnt needed
sudo echo "server{
        listen 80;
        server_name _;
        location / {
        proxy_pass http://192.168.10.100:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        }
}" >> /etc/nginx/sites-available/default
# Restarts nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
# Reseeds the database and runs the web-server
cd app
node seeds/seed.js 
node app.js
