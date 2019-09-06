# -*- mode: ruby -*-
# vi: set ft=ruby :

# Server Configuration
hostname                = "znz"

# Synced folder
host_projects_dir       = "e:/VBoxes/Sites"
guest_projects_dir      = "/home/vagrant/sites"

# Set a local private network IP address.
# See http://en.wikipedia.org/wiki/Private_network for explanation
# You can use the following IP ranges:
#   10.0.0.1    - 10.255.255.254
#   172.16.0.1  - 172.31.255.254
#   192.168.0.1 - 192.168.255.254
server_ip               = "192.168.8.12"
server_cpus             = "2"   # Cores
# MariaDB may throw errors during "vagrant up" with less than 1024MB memory
server_memory           = "2048" # MB
server_timezone         = "America/New_York"
server_swap             = "768" # Options: false | int (MB) - Guideline: Between one or two times the server_memory

# can be altered to your prefered locale, see http://docs.moodle.org/dev/Table_of_locales
locale_language         = "en_US"
locale_codeset          = "en_US.UTF-8"

# Database Configuration
mysql_root_password     = "" # We'll assume user "root"
mariadb_version         = "10.3" # Options: 5.5 | 10.0 | 10.1 | 10.2 | 10.3
mysql_enable_remote     = "false" # remote access enabled when true

# Languages and Packages
php_timezone            = server_timezone # http://php.net/manual/en/timezones.php
php_version             = "7.3"           # Options: 5.6 | 7.0 | 7.1 | 7.2 | 7.3

composer_packages     = [        # List any global Composer packages that you want to install
  "phpunit/phpunit:6.5.*@dev",
  "codeception/codeception=*",
  #"phpspec/phpspec:2.0.*@dev",
  #"squizlabs/php_codesniffer:1.5.*",
]

# Default web server document root
# Symfony's public directory is assumed "web"
# Laravel's public directory is assumed "public"

laravel_root_folder   = "laravel" # Where to install Laravel. Will `composer install` if a composer.json file exists
laravel_public_folder = "public"
laravel_version       = "latest-stable" # If you need a specific version of Laravel, set it here
laravel_server_name   = laravel_root_folder + "." + server_ip + ".xip.io"
symfony_root_folder   = "symfony" # Where to install Symfony.
symfony_public_folder = "web"

# NodeJS
nodejs_version          = "11" # Options: 6 | 8 | 10 | 11
nodejs_packages         = [    # List any global NodeJS packages that you want to install
  "gulp-cli"
  #"grunt-cli",
  #"bower",
  #"yo",
]

# WP Cli
wpcli_sites             = [     # List url of any wp sites that you want to install
  "theme.dev"
]

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "centos/7"

  # Create a hostname, don't forget to put it to the `hosts` file
  # This will point to the server's default virtual host
  config.vm.hostname = hostname

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: server_ip

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder host_projects_dir, guest_projects_dir

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider :virtualbox do |vb|
      vb.name = "vagrant_"+config.vm.hostname

      # Enable symlinks
      # vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/"+host_projects_dir, "1"]

      vb.customize [
        "modifyvm", :id,
        "--pae", "on",
        "--cpus", server_cpus,
        "--memory", server_memory
      ]

      # Set the timesync threshold to 10 seconds, instead of the default 20 minutes.
      # If the clock gets more than 15 minutes out of sync (due to your laptop going
      # to sleep for instance, then some 3rd party services will reject requests.
      vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]

      # Prevent VMs running on Ubuntu to lose internet connection
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  # Turn SELinux to permissive
  config.vm.provision "shell", run: "always", inline: "sudo setenforce 0"

  ####
  # Base Items
  ##########

  # Provision Base Packages + Updates
  #config.vm.provision "shell", path: "scripts/base.sh", args: [hostname, locale_language, locale_codeset, server_timezone]

  # Provision PHP
  #config.vm.provision "shell", path: "scripts/php.sh", args: [php_timezone, php_version]


  ####
  # Web Servers
  ##########

  # Provision Nginx Base
  #config.vm.provision "shell", path: "scripts/nginx.sh", args: [server_ip, guest_projects_dir]

  # After Php + Nginx
  # Can't start any of them before both of them are installed
  #config.vm.provision "shell", path: "scripts/afterphpnginx.sh"

  ####
  # Databases
  ##########

  # Provision MySQL
  # config.vm.provision "shell", path: "scripts/mysql.sh", args: [mysql_root_password, mariadb_version, mysql_enable_remote, guest_projects_dir]

  # Provision MariaDB
  #config.vm.provision "shell", path: "scripts/mariadb.sh", args: [mysql_root_password, mariadb_version, mysql_enable_remote, guest_projects_dir]


  ####
  # In-Memory Stores
  ##########

  # Install Memcached
  # config.vm.provision "shell", path: "scripts/memcached.sh"


  ####
  # Additional Languages
  ##########

  # Install Nodejs
  #config.vm.provision "shell", path: "scripts/nodejs.sh", privileged: false, args: nodejs_packages.unshift(nodejs_version)

  ####
  # CMS
  ##########
  # Install wp-cli
  # config.vm.provision "shell", path: "scripts/wp-cli.sh", privileged: false, args: wpcli_sites.unshift(guest_projects_dir)
  wpcli_sites=wpcli_sites.unshift(guest_projects_dir)
  #config.vm.provision "shell", path: "scripts/wp-cli1.sh", privileged: false, args: wpcli_sites.unshift(server_ip)

  ####
  # Frameworks and Tooling
  ##########
  #config.vm.provision "shell", path: "scripts/composer.sh", privileged: false, args: [composer_packages.join(" ")]

  # Provision Laravel
  # config.vm.provision "shell", path: "scripts/laravel.sh", privileged: false, args: [guest_projects_dir, laravel_root_folder, laravel_public_folder, laravel_version, laravel_server_name]

  # Provision Symfony
  # config.vm.provision "shell", path: "scripts/symfony.sh", privileged: false, args: [server_ip, symfony_root_folder, symfony_public_folder]
end
