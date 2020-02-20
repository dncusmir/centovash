#!/usr/bin/env bash

# args: nume_proiect
# run din ~/sites: bash /vagrant/extra/laravel-project.sh nume_proiect

nume_proiect=$1
nume_lower="${nume_proiect,,}"
url=$nume_lower.192.168.8.12.xip.io;
parent_dir=~/sites
path=$parent_dir/$nume_proiect
public_folder=public

echo "### setting up laravel project "$nume_proiect
cd $parent_dir
composer create-project --prefer-dist Laravel/Laravel $nume_proiect

echo "## setting up auth + vue scaffolding"
cd $path
composer require laravel/ui
php artisan ui vue --auth
echo "# fixing node_modules long name bug"
node_modules=$nume_proiect"_node_modules"
sudo mkdir ~/$node_modules
sudo chown -R vagrant:vagrant ~/$node_modules
cd ~/$node_modules
sudo cp $path/package.json .
npm install
sudo ln -s ~/$node_modules/node_modules $path/node_modules
cd $path
echo "# Run all Mix tasks and minify output"
sudo sed -i "s#css')#css').sourceMaps()#" webpack.mix.js
npm run dev

echo "### copy-ing nginx conf file"
sudo cp /vagrant/extra/laravel-nginx.conf /etc/nginx/sites-available/$nume_lower.conf

echo "## editting "$nume_lower".conf"
sudo sed -i "s@server_name  server_name@server_name  $url@" /etc/nginx/sites-available/$nume_lower.conf
sudo sed -i "s@root_folder@$path@" /etc/nginx/sites-available/$nume_lower.conf
sudo sed -i "s@public_folder@$public_folder@" /etc/nginx/sites-available/$nume_lower.conf

echo "## creating symlink in sites-enabled"
sudo ln -s /etc/nginx/sites-available/$nume_lower.conf /etc/nginx/sites-enabled/$nume_lower.conf

echo "### creating log files"
if [ ! -d "${path}" ]; then
    sudo mkdir $path
fi
dirname=$path"/logs"
if [ ! -d "${dirname}" ]; then
    sudo mkdir $dirname
fi
sudo touch $path/logs/access.log
sudo touch $path/logs/error.log

echo "### restarting nginx"
sudo systemctl restart nginx