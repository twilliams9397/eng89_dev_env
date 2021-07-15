# Multi Machines
- Use one vagrant file to launch 2 VMs
- One VM for app (already done) one called db (with mongodb installed)
- Connect app VM to db VM with variable in app environment
- look at https://www.vagrantup.com/docs/multi-machine
![MicrosoftTeams-image.png] (MicrosoftTeams-image.png)

- Vagrantfile updated for multi-machine:
```ruby
# ruby syntax

Vagrant.configure("2") do |config|

 config.vm.define "app" do |app|

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
    app.vm.provision "shell", path: "./environment/provision.sh"

  end

  config.vm.define "db" do |db|

    db.vm.box = "ubuntu/xenial64"
    db.vm.network "private_network", ip: "192.168.10.150"
    db.hostsupdater.aliases = ["database.local"] 
    db.vm.synced_folder "db_environment", "/home/vagrant/db_environment"
    db.vm.provision "shell", path: "./db_environment/provision.sh"

  end

end


```
- VMs run using same vagrant commands, but specific to machine - `vagrant up db` etc
- new provision.sh created for db VM to install MongoDB


### Steps to launch db and app and link app to database
- ensure each provision.sh has correct installs and any necessary restarts after updating of conf files
- ensure Vagrantfile is setting any required environment variables
- `vagrant up db`
- `vagrant up app && vagrant ssh app`
- `npm start`















