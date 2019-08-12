#!/usr/bin/env bash

echo ">>> Installing MariaDB"

#[[ -z $1 ]] && { echo "!!! MariaDB root password not set. Check the Vagrant file."; exit 1; }

# Copy repo
sudo cp /vagrant/extra/mariadb$2.repo /etc/yum.repos.d/

# Update if necessary
sudo yum -y update

# Install mariadb
sudo yum install -y MariaDB-server MariaDB-client

# Make Maria connectable from outside world without SSH tunnel
if [ $3 == "true" ]; then
    printf "\n\nConfiguring remote MySQL access...\n"

    # enable remote access
    # setting the mysql bind-address to allow connections from everywhere
    sudo sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

    # adding grant privileges to mysql root user from everywhere
    # thx to http://stackoverflow.com/questions/7528967/how-to-grant-mysql-privileges-in-a-bash-script for this
    Q1="GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$1' WITH GRANT OPTION;"
    Q2="FLUSH PRIVILEGES;"
    SQL="${Q1}${Q2}"

    sudo mysql -uroot --password=$1 -e "$SQL"
fi

sudo systemctl restart mysql

# Check for SQL files to import
for path in $4/*; do
    if [ -d "${path}" ]; then
        dirname="$(basename "${path}")"

        if [ -f $path/*.sql ]; then
            sql_file="$(basename "${path}"/*.sql)"
            filename=${sql_file%.*}
            # Convert any . (dots) in the filename to underscores (you can't have dots in a database name)
            db_name=${dirname//./_}
            db_name=$db_name"_db"

            sudo mysql -uroot --password=$1 -e "CREATE DATABASE IF NOT EXISTS $db_name CHARACTER SET utf8 COLLATE utf8_general_ci"
            sudo mysql -uroot --password=$1 $db_name < ${path}"/"$filename.sql

            printf "Database created & imported for $dirname...\n"
        else
            printf "No database to import for $dirname...\n"
        fi
    fi
done

##### Complete #####
printf "\n\nMySQL provisioning complete. Remember to dump the database before destroying the VM by using the following SQL:\n
mysqldump -uroot -proot DBNAME > /path/to/project/vagrant/db/dump/dump.sql\n"
