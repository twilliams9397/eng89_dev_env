# Reverse Proxies
- in real life we dont use ports to access websites - e.g. port 3000 was used to access nginx app initially
- to load pages without explicitly expressing ports, we can either reconfigure the default files or create new files with only the required info
### Find/edit default file
- `cd /etc/nginx/sites-available/` in the home location of the vm - `cd` command will get there
- `sudo nano default` will open the file for editing
- by using `rm -rf default` first this will delete the file and then the `nano` command will create a blank file with this name
- after creating/editing the file `sudo nginx -t` will test if the file is correctly formatted and runs
- `sudo systemctl restart nginx` and `sudo systemctl status nginx` will restart nginx with the new default file and checks the status
- `npm start` will now start the app (from the app folder) with this new configuration