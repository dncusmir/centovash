#!/usr/bin/env bash

# Install PHP
printf "\n\nInstalling PHP ($2)...\n"

# Add repo for PHP
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
wget https://rpms.remirepo.net/enterprise/remi-release-7.rpm
rpm -Uvh remi-release-7.rpm epel-release-latest-7.noarch.rpm

if [ $2 == "5.6" ]; then
    yum -y --enablerepo=remi-php56 install php-fpm php-cli php-mysqlnd php-xml php-json php-pecl-memcached php-gd php-mbstring php-pdo php-common php-imap  php-mcrypt php-curl  php-imagick  php-intl php-xdebug
elif [ $2 == "7.0" ]; then
    yum -y --enablerepo=remi-php70 install php-fpm php-cli php-mysqlnd php-xml php-json php-pecl-memcached php-gd php-mbstring php-pdo php-common php-imap  php-mcrypt php-curl  php-imagick  php-intl php-xdebug
elif [ $2 == "7.1" ]; then
    yum -y --enablerepo=remi-php71 install php-fpm php-cli php-mysqlnd php-xml php-json php-pecl-memcached php-gd php-mbstring php-pdo php-common php-imap  php-mcrypt php-curl  php-imagick  php-intl php-xdebug
elif [ $2 == "7.2" ]; then
    yum -y --enablerepo=remi-php72 install php-fpm- php-cli php-mysqlnd php-xml php-json php-pecl-memcached php-gd php-mbstring php-pdo php-common php-imap  php-mcrypt php-curl  php-imagick  php-intl php-xdebug
elif [ $2 == "7.3" ]; then
    yum -y --enablerepo=remi-php73 install php-fpm php-cli php-mysqlnd php-xml php-json php-pecl-memcached php-gd php-mbstring php-pdo php-common php-imap  php-mcrypt php-curl  php-imagick  php-intl php-xdebug
fi


##### PHP Configuration #####

# Set PHP FPM to listen on Socket instead of TCP
# Listens on 127.0.0.1:9000 by default
sudo sed -i "s/listen = 127.0.0.1:9000/listen = \/run\/php-fpm\/www.sock/" /etc/php-fpm.d/www.conf
#sudo sed -i "s/;listen = /run/php-fpm/www.sock/listen = /run/php-fpm/www.sock/" /etc/php-fpm.d/www.conf

# Set PHP FPM allowed clients IP address
sudo sed -i "s/;listen.allowed_clients/listen.allowed_clients/" /etc/php-fpm.d/www.conf

# Set PHP FPM Access Control Lists
#sudo sed -i "s/;listen.acl_users = nginx/listen.acl_users = nginx/" /etc/php-fpm.d/www.conf
sudo sed -i "/listen.acl_users = apache,nginx/a listen.acl_users = vagrant" /etc/php-fpm.d/www.conf

# Set run-as user for PHP-FPM processes to user/group "vagrant"
# to avoid permission errors from apps writing to files
sudo sed -i "s/user = apache/user = vagrant/" /etc/php-fpm.d/www.conf
sudo sed -i "s/group = apache/group = vagrant/" /etc/php-fpm.d/www.conf
sudo sed -i "s/;listen\.owner.*/listen.owner = vagrant/" /etc/php-fpm.d/www.conf
sudo sed -i "s/;listen\.group.*/listen.group = vagrant/" /etc/php-fpm.d/www.conf
sudo sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php-fpm.d/www.conf


# PHP Error Reporting config
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php.ini

# PHP timezone
sudo sed -i "s/;date.timezone =.*/date.timezone = ${1/\//\\/}/" /etc/php.ini

# Memory limit
sudo sed -i "s/memory_limit = 128M/memory_limit = 512M/" /etc/php.ini

##### Complete #####
printf "\n\nPHP provisioning complete.\n"
