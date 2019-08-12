#!/usr/bin/env bash

# Setting up wp Sites
echo ">>> setting up wp site "$2

# Setting up directory
#mysql_root_password=$1
dirname=$1"/"$2
fixed_dir=${2//./_}
db_name=$fixed_dir"_db"
db_root=$fixed_dir"_root"
db_pass=$fixed_dir"_pass"
site_url="http://www.theme.dev.192.168.8.12.xip.io"

if [ ! -d "${dirname}" ]; then
    sudo mkdir $dirname
fi
dirname=$dirname"/public_html"
if [ ! -d "${dirname}" ]; then
    sudo mkdir $dirname
fi

# Download WordPress
wp core download --path=$dirname

# Create database
Q1="CREATE DATABASE IF NOT EXISTS $db_name CHARACTER SET utf8 COLLATE utf8_general_ci;"
Q2="GRANT ALL ON $db_name.* TO '$db_root'@'localhost' IDENTIFIED BY '$db_pass';"
Q3="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}"
sudo mysql -uroot --password='' -e "$SQL"

# Create wp config
wp config create --dbname=$db_name --dbuser=$db_root --dbpass=$db_pass --path=$dirname

# Create database structure
wp db create --path=$dirname

# WordPress install
wp core install --url=$site_url --title="WP-CLI" --admin_user=wpcli --admin_password=wpcli --admin_email=info@wp-cli.org --path=$dirname

# Update plugins
wp plugin update --all --path=$dirname

# Update themes
wp theme update --all --path=$dirname

#sudo cp /vagrant/extra/wp-nginx.conf /etc/nginx/sites-available
#sudo ln -s /etc/nginx/sites-available/wp-nginx.conf /etc/nginx/sites-enabled/
#sudo systemctl reload nginx
sudo cp /vagrant/extra/theme.dev.conf /etc/nginx/sites-available
sudo ln -s /etc/nginx/sites-available/theme.dev.conf /etc/nginx/sites-enabled/
sudo nginx -s reload
