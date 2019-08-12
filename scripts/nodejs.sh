#!/usr/bin/env bash

# Contains all arguments that are passed
NODE_ARG=($@)

# Number of arguments that are given
NUMBER_OF_ARG=${#NODE_ARG[@]}

# Prepare the variables for installing specific Nodejs version and additional Packages
if [[ $NUMBER_OF_ARG -gt 1 ]]; then
    # Nodejs version and additional Node Packages are given
    NODEJS_VERSION=${NODE_ARG[0]}
    NODE_PACKAGES=${NODE_ARG[@]:1}
else
    # Default Nodejs version
    NODEJS_VERSION=${NODE_ARG[0]}
fi

# Add repo
sudo curl -sL https://rpm.nodesource.com/setup_$NODEJS_VERSION.x | sudo bash -

# Install nodejs
echo ">>> Installing Node.js version $1"
sudo yum -y install nodejs

# Install build tools
sudo yum -y install gcc-c++ make

# Install additional NodeJS Packages
if [[ ! -z $NODE_PACKAGES ]]; then
    echo ">>> Start installing Global Node Packages"
    echo ">>> "${NODE_PACKAGES[@]}

    sudo npm install -g ${NODE_PACKAGES[@]}
fi
