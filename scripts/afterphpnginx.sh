#!/usr/bin/env bash

##### Starting php #####
printf "\n\nStarting PHP ...\n"
sudo systemctl enable php-fpm
sudo systemctl restart php-fpm

##### Starting Nginx #####
printf "\n\nStarting Nginx ...\n"
#sudo systemctl enable nginx
#sudo systemctl restart nginx
sudo /usr/sbin/nginx -c /etc/nginx/nginx.conf
