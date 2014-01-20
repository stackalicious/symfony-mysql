#!/bin/bash
SITE="$1"

HOME="/home/vagrant"

SHARE_ROOT="/vagrant"
SYNC="${SHARE_ROOT}/sites"
PROJ="${SYNC}/${SITE}"

DB_NAME="$SITE"
DB_USER="$2"
DB_PASS="$3"

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
sudo apt-get -q -y install php5 php5-mysql 
echo 
echo "Configure php.ini"
sed -i "s/\(disable_functions = *\).*/\1/" /etc/php5/cli/php.ini
sed -i "s/\(memory_limit = *\).*/\1-1/" /etc/php5/cli/php.ini
sed -i "s/.*\(date.timezone *=\).*/\1 America\/Los_Angeles/" /etc/php5/cli/php.ini
sed -i "s/.*\(date.timezone *=\).*/\1 America\/Los_Angeles/" /etc/php5/apache2/php.ini
echo "---------------------------------------"

# Run app specific configuration
if [ -f $PROJ/setup_app.sh ]; then
  cd $PROJ
  source setup_app.sh $1 $2 $3
fi
