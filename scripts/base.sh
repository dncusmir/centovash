#!/usr/bin/env bash

##### Server Configuration #####

# Hostname
printf "\n\nSetting hostname...\n"
sudo hostnamectl set-hostname $1

# Set Locale
sudo localectl set-locale LANG=$3

# Set timezone
printf "\n\nSetting timezone...\n"
echo $4
sudo timedatectl set-timezone $4

# Download and update package lists
printf "\n\nPackage manager updates...\n"
sudo yum clean all
sudo rpm --rebuilddb
sudo yum -y update

# Install or update base packages of needed
printf "\n\nInstalling base packages...\n"
sudo yum install -y wget curl make openssl
# nfs-common unzip zip checkinstall

# SELinux 0
sudo setenforce 0

##### Complete #####
printf "\n\nBase provisioning complete.\n"
