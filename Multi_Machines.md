# Multi Machines
- Use one vagrant file to launch 2 VMs
- One VM for app (already done) one called db (with mongodb installed)
- Connect app VM to db VM with variable in app environment
- look at https://www.vagrantup.com/docs/multi-machine
![MicrosoftTeams-image.png] (MicrosoftTeams-image.png)

- Vagrantfile updated for multi-machine:
```ruby
# ruby syntax

# def set_env vars
#   command = <<~HEREDOC
#     echo "Setting Environment Variables"
#     source ~/.bashrc
#   HEREDOC

#   vars.each do |key, value|
#     command += <<~HEREDOC
#       if [ -z "$#{key}" ]; then
#         echo "export #{key}=#{value}" >> ~/.bashrc
#       fi
#     HEREDOC
#   end



#   return command
# end

Vagrant.configure("2") do |config|

 config.vm.define "app" do |app| # configures first VM - app

  app.vm.box = "ubuntu/xenial64"
  # using ubuntu 16.04 LTS box
  
  # let's connect to nginx using private ip
    app.vm.network "private_network", ip: "192.168.10.100"
  # we would like to load this ip using our host machine's browser
  # to view default nginx page
   
    app.hostsupdater.aliases = ["development.local"]
    # if the plugin is installed correctly and file is update with vagrant destroy then vagrant up
    # we should be able to see nginx page in the browser with http://development.local 

    # syncing folder from host to VM
    app.vm.synced_folder "app/", "/home/vagrant/app/"
    app.vm.synced_folder "environment/", "/home/vagrant/environment/"

    # executing provision.sh in VM
    app.vm.provision "shell", path: "./environment/provision.sh", env: {'DB_HOST' => 'mongodb://192.168.10.150:27017/posts'}
    # setting environment variable

  end

  config.vm.define "db" do |db| # configures second VM - db

    db.vm.box = "ubuntu/xenial64" # same ubuntu box
    db.vm.network "private_network", ip: "192.168.10.150" # new private up
    db.hostsupdater.aliases = ["database.local"] 
    db.vm.synced_folder "db_environment", "/home/vagrant/db_environment" # different folder synced
    db.vm.provision "shell", path: "./db_environment/provision.sh" # different provisioning for setup

  end

end
```
- VMs run using same vagrant commands, but specific to machine - `vagrant up db` etc
- new provision.sh created for db VM to install MongoDB

### New app provison.sh
```ruby
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
```

### New db provision.sh
```ruby
#!/bin/bash

sudo apt-get install gnupg

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927
echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y mongodb-org=3.2.20 mongodb-org-server=3.2.20 mongodb-org-shell=3.2.20 mongodb-org-mongos=3.2.20 mongodb-org-tools=3.2.20 --allow-unauthenticated

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - 
sudo apt-get install -y nodejs

# install pm2 package manager
npm install pm2 -g 

sudo apt-get install python-software-properties -y

cd /etc
sudo rm -rf mongod.conf # deletes config file for mongdb
# rewrites config file with 0.0.0.0 ip for ease of access
sudo echo "
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log
net:
  port: 27017
  bindIp: 0.0.0.0
" >> mongod.conf

# restarts and enables with new config
sudo systemctl restart mongod
sudo systemctl enable mongod

```

### Steps to launch db and app and link app to database
- ensure each provision.sh has correct installs and any necessary restarts after updating of conf files
- ensure Vagrantfile is setting any required environment variables
- `vagrant up db && vagrant up app` to run















