#!/bin/bash
# Switch to root user
sudo -i

# Update and install necessary packages
# apt update
apt install nginx -y

# Create Nginx configuration file for vproapp
cat <<EOL > /etc/nginx/sites-available/vproapp
upstream vproapp {
    server app01:8080;
}
server {
    listen 80;
    location / {
        proxy_pass http://vproapp;
    }
}
EOL

# Remove default nginx conf
rm -rf /etc/nginx/sites-enabled/default

# Create link to activate website
ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp
systemctl restart nginx