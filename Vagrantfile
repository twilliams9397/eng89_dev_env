# ruby syntax

def set_env vars
  command = <<~HEREDOC
  echo "Setting Environment Variables"
  source ~/.bashrc
  HEREDOC

  vars.each do |key, value|
    command += <<~HEREDOC
    if [ -z "$#{key}" ]; then
    echo "export #{key}=#{value}" >> ~/.bashrc
    fi
    HEREDOC
  end



  return command
end

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
    # setting environment variable
    app.vm.provision "shell", inline: set_env({ DB_HOST: "mongodb://192.168.10.150:27017/posts" })

  end

  config.vm.define "db" do |db|

    db.vm.box = "ubuntu/xenial64"
    db.vm.network "private_network", ip: "192.168.10.150"
    db.hostsupdater.aliases = ["database.local"] 
    db.vm.synced_folder "db_environment", "/home/vagrant/db_environment"
    db.vm.provision "shell", path: "./db_environment/provision.sh"

  end

end
