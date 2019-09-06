#!/usr/bin/env bash

# args: [guest_projects_dir, laravel_root_folder, public_folder, laravel_version, laravel_server_name]

echo ">>> Installing Laravel"

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

[[ $PHP_IS_INSTALLED -ne 0 ]] && { printf "!!! PHPis not installed.\n    Installing Laravel aborted!\n"; exit 0; }

# Installing php extensions needed
PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
yum -y --enablerepo=remi-php${PHP_VERSION/./} install php-bcmath php-json php-mbstring php-pdo php-xml

# Test if Composer is installed
composer -v > /dev/null 2>&1 || { printf "!!! Composer is not installed.\n    Installing Laravel aborted!"; exit 0; }

# Test if Server IP is set in Vagrantfile
[[ -z "$1" ]] && { printf "!!! IP address not set. Check the Vagrantfile.\n    Installing Laravel aborted!\n"; exit 0; }

laravel_root_folder="$1/$2"
laravel_public_folder="$laravel_root_folder/$3"

# Test if Apache or Nginx is installed
nginx -v > /dev/null 2>&1
NGINX_IS_INSTALLED=$?

apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

# Create Laravel folder if needed
if [[ ! -d $laravel_root_folder ]]; then
    mkdir -p $laravel_root_folder
fi

if [[ ! -f "$laravel_root_folder/composer.json" ]]; then
    # Create Laravel
    if [[ "$4" == 'latest-stable' ]]; then
         composer create-project --prefer-dist laravel/laravel $laravel_root_folder
    else
         composer create-project laravel/laravel:$4 $laravel_root_folder
    fi
else
    # Go to vagrant folder
    cd $laravel_root_folder
    composer install --prefer-dist

    # Go to the previous folder
    cd -
fi

if [[ $NGINX_IS_INSTALLED -eq 0 ]]; then
    # Change default vhost created
    sudo bash /vagrant/extra/nginx-init-site.sh $1 $5 $2 $3
    #[guest_projects_dir, laravel_root_folder, public_folder, laravel_version]
    #laravel_root_folder="$1/$2"
    #laravel_public_folder="$laravel_root_folder/$3"
    #guest_projects_dir ?server_name root_folder public_folder
    # sudo systemctl reload nginx
    sudo systemctl is-active --quiet nginx && sudo systemctl reload nginx
fi