#!/usr/bin/env bash

# args: server_ip guest_projects_dir 'site1 site2 ...'

# Installing
printf "\n\nInstalling wp-cli...\n"
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Make it executable
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/bin/wp

# Contains all arguments that are passed
WP_ARG=($@)

# Number of arguments that are given
NUMBER_OF_ARG=${#WP_ARG[@]}

if [[ $NUMBER_OF_ARG -gt 2 ]]; then
    ip=${WP_ARG[0]}
    path=${WP_ARG[1]}
    urls=${WP_ARG[@]:2}
    echo ">>> "$urls
    for item in $urls; do
        bash /vagrant/extra/wp-cli-init-site1.sh $ip $path $item
    done
fi
