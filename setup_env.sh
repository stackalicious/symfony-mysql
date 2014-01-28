#!/bin/bash

HOME="/home/vagrant"

SHARE_ROOT="/vagrant"
SYNC="${SHARE_ROOT}/sites"

DB_USER="$1"
DB_PASS="$2"

area="America"
zone="Los_Angeles"
locale="en_US.UTF-8"

echo
echo "---------------------------------------"
echo "Setting Locale, Timezone, and Time Server"

if [ ! "$LANG" == "$locale" ]; then
    export LANGUAGE=$locale
    export LANG=$locale
    export LC_ALL=$locale
    locale-gen $locale
    dpkg-reconfigure locales
    
    #sudo tee /etc/default/locale <<EOF > /dev/null
    #LANG=$encoding
    #LANGUAGE=$locale
#EOF
fi

echo \"$area/$zone\" | sudo tee /etc/timezone > /dev/null
sudo cp -f /usr/share/zoneinfo/$area/$zone /etc/localtime
#sudo dpkg-reconfigure --frontend noninteractive tzdata #Correct method does not work in 12.04

sudo apt-get -q -y install ntp

echo "---------------------------------------"
echo

echo "---------------------------------------"
echo "Setup Apache"
sudo apt-get -q -y install htop vim apache2 


# For HPCloud images a fallback server is needed to suppress apache error messages 
# May be fixed with better base image or ubuntu release
if ! grep -qe "^ServerName localhost$" /etc/apache2/httpd.conf; then 
    echo "Adding fallback server name to httpd.conf";
    echo "ServerName localhost" | sudo tee -a /etc/apache2/httpd.conf > /dev/null;
fi
echo "---------------------------------------"
echo

echo "---------------------------------------"
echo "Setup php"
sudo apt-get -q -y install php5 php5-curl php-pear php5-mysql
if lsb_release -r | grep -o '12.04' > /dev/null ; then 
     sudo apt-get -q -y install php5-suhosin; 
fi

sed -i "s/\(disable_functions = *\).*/\1/" /etc/php5/cli/php.ini
sed -i "s/\(memory_limit = *\).*/\1-1/" /etc/php5/cli/php.ini
sed -i "s/.*\(date.timezone *=\).*/\1 $area\/$zone/" /etc/php5/cli/php.ini
sed -i "s/.*\(date.timezone *=\).*/\1 $area\/$zone/" /etc/php5/apache2/php.ini
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
