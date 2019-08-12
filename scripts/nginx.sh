#!/usr/bin/env bash

# Install Nginx
printf "\n\nInstalling Nginx...\n"

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

[[ -z $1 ]] && { echo "!!! IP address not set. Check the Vagrant file.\n"; exit 1; }

# Add repo for latest stable / mainline nginx
sudo cp /vagrant/extra/nginx.repo /etc/yum.repos.d/

# Update Again
sudo yum -y update

# Install Nginx stable
# sudo yum -y --enablerepo=nginx-stable install nginx

# Install Nginx mainline
sudo yum -y --enablerepo=nginx-mainline install nginx

# Turn off sendfile to be more compatible with Windows, which can't use NFS
sudo sed -i 's/sendfile/#sendfile/' /etc/nginx/nginx.conf
sudo sed -i '/;sendfile/a sendfile off;' /etc/nginx/nginx.conf

# load site conf din /etc/nginx/sites-enabled/
sudo sed -i "/include \/etc\/nginx\/conf.d\/\*.conf;/a include \/etc\/nginx\/sites-enabled\/*;" /etc/nginx/nginx.conf

# Set run-as user for PHP-FPM processes to user/group "vagrant"
# to avoid permission errors from apps writing to files
sudo sed -i "s/user  nginx;/user vagrant;/" /etc/nginx/nginx.conf
#sudo sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf
sudo sed -i "/sendfile off;/a server_names_hash_bucket_size 64;" /etc/nginx/nginx.conf

# Add vagrant user to nginx group
sudo usermod -a -G nginx vagrant

# upstream php-fpm
sudo cp /vagrant/extra/php-fpm.conf /etc/nginx/conf.d/

# nginx sites directories
if [ ! -d "/etc/nginx/sites-available" ]; then sudo mkdir /etc/nginx/sites-available; fi
if [ ! -d "/etc/nginx/sites-enabled" ]; then sudo mkdir /etc/nginx/sites-enabled; fi

# Each project will have its nginx config stored in a vagrant/nginx directory so copy that over like we did with apache config below
# My mysql init.sql import script may help with this (looping over the folders etc)
for path in $2/*; do
    if [ -d "${path}" ]; then
        dirname="$(basename "${path}")"

        if [ -f $path/*.conf ]; then
            conf_file="$(basename "${path}"/*.conf)"
            filename=${conf_file%.*}

            sudo cp ${path}"/"$filename.conf /etc/nginx/sites-available/$dirname.conf

            sudo ln -s /etc/nginx/sites-available/$dirname.conf /etc/nginx/sites-enabled/
            sudo mkdir -p $path/logs

            printf "Nginx config imported for $dirname...\n"
        else
            printf "No Nginx config to import for $dirname...\n"
        fi
    fi
done

if [[ $PHP_IS_INSTALLED -eq 0 ]]; then
    # PHP-FPM Config for Nginx
    sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php.ini

fi


##### Complete #####
printf "\n\nNginx provisioning complete.\n"
