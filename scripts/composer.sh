#!/usr/bin/env bash

# args: package1 package2 ...

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

[[ $PHP_IS_INSTALLED -ne 0 ]] && { printf "!!! PHP is not installed.\n    Installing Composer aborted!\n"; exit 0; }

# Test if Composer is installed
composer -v > /dev/null 2>&1
COMPOSER_IS_INSTALLED=$?

# True, if composer is not installed
if [[ $COMPOSER_IS_INSTALLED -ne 0 ]]; then
    EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

    if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
    then
        >&2 echo 'ERROR: Invalid installer signature'
        rm composer-setup.php
        exit 1
   fi

   php composer-setup.php --quiet
   RESULT=$?
   rm composer-setup.php
   # error installing
   if [[ $RESULT -ne 0 ]]; then
   	echo 'ERROR: installing composer'
	exit 1
   fi
   # Make it executable
   sudo chmod +x composer.phar
   sudo mv composer.phar /usr/bin/composer
else
    echo ">>> Updating Composer"
    composer self-update
fi

# Install Global Composer Packages if any are given
COMPOSER_PACKAGES=$1
if [[ ! -z $COMPOSER_PACKAGES ]]; then
    echo ">>> Installing Global Composer Packages:"
    echo "    " ${COMPOSER_PACKAGES[@]}
        composer global require ${COMPOSER_PACKAGES[@]}
fi