#!/usr/bin/env bash

# args: guest_projects_dir server_name root_folder public_folder

# copy sample laravel nginx.conf
sudo cp /vagrant/extra/laravel-nginx.conf /etc/nginx/sites-available/$3.conf
sudo ln -s /etc/nginx/sites-available/$3.conf /etc/nginx/sites-enabled/
path=$1/$3
sudo mkdir -p $path/logs

# edit the conf file to match our new laravel installation
sudo sed -i "s@server_name  server_name@server_name  $2@" /etc/nginx/sites-available/$3.conf
sudo sed -i "s@root_folder@$path@" /etc/nginx/sites-available/$3.conf
sudo sed -i "s@public_folder@$4@" /etc/nginx/sites-available/$3.conf
#sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php.ini