#!/bin/bash

HOME="/home/vagrant"

SHARE_ROOT="/vagrant"
SYNC="${SHARE_ROOT}/sites"

DB_USER="$1"
DB_PASS="$2"

echo
echo "---------------------------------------"
echo "Setting Locale & timezone"
sudo tee /etc/default/locale <<EOF > /dev/null
LANG="en_US.UTF-8"
LANGUAGE="en_US:en"
EOF
echo \"America/Los_Angeles\" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata
echo "---------------------------------------"
echo

echo
echo "---------------------------------------"
echo "Updating System Clock"
echo
sudo ntpdate -u pool.ntp.org
echo "---------------------------------------"

echo
echo "---------------------------------------"
echo "Install Applications"
sudo apt-get update
sudo apt-get -q -y install htop vim apache2 
echo "---------------------------------------"
echo

if ! grep -qe "^ServerName localhost$" /etc/apache2/apache2.conf; then 
    echo "----------------------------------------"
    echo "Add fallback server name to apache2.conf";
    echo "ServerName localhost" | sudo tee -a /etc/apache2/apache2.conf;
    echo "----------------------------------------";
fi

echo "---------------------------------------"
echo "Install php"
sudo apt-get -q -y install php5 php5-mysql php5-curl
echo 
echo "Configure php.ini"
sed -i "s/\(disable_functions = *\).*/\1/" /etc/php5/cli/php.ini
sed -i "s/\(memory_limit = *\).*/\1-1/" /etc/php5/cli/php.ini
sed -i "s/.*\(date.timezone *=\).*/\1 America\/Los_Angeles/" /etc/php5/cli/php.ini

sed -i "s/\(disable_
functions = *\).*/\1/" /etc/php5/apache2/php.ini
sed -i "s/\(memory_limit = *\).*/\1-1/" /etc/php5/apache2/php.ini
sed -i "s/.*\(date.timezone *=\).*/\1 America\/Los_Angeles/" /etc/php5/apache2/php.ini
echo "---------------------------------------"

# Run app specific configuration
for dir in ${SYNC}/*/
do
    cd $dir
    
    #Remember basename of the current directory
    site=${PWD##*/};
    
    if [ ! -f ${dir}/setup_app.sh ]; then
      echo "Skipping $site because setup_app.sh not found."
      continue;
    fi
    
    DBNAME=$site
    source setup_app.sh $DBNAME $DBUSER $DBPASS
done
