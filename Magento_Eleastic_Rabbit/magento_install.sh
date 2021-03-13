#!/bin/bash

# Install apache2

sudo apt install -y apache2
sudo systemctl enable apache2 --now

# Verifyin apache2 process status
# If "Active" script will continue
# If "Inactive" script will exit with code 1

if [[ "$(systemctl status apache2 | grep Active | awk '{print $3}' | cut -c 2- | sed 's/.$//')" == "running" ]]; then
    :
else
    echo Please verify apache2 installation
    exit 1
fi

cat > /etc/apache2/sites-available/magento.conf <<END
<VirtualHost *:80>
     ServerAdmin admin@domain.com
     DocumentRoot /var/www/html/magento/
     ServerName domain.com
     ServerAlias www.domain.com

     <Directory /var/www/html/magento/>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
     </Directory>

     ErrorLog ${APACHE_LOG_DIR}/magento_error.log
     CustomLog ${APACHE_LOG_DIR}/magento_access.log combined
</VirtualHost>
END

a2ensite magento.conf
a2enmod rewrite

sudo apt install -y php7.2 libapache2-mod-php7.2 php7.2-common php7.2-gmp php7.2-curl php7.2-soap php7.2-bcmath php7.2-intl php7.2-mbstring php7.2-xmlrpc php7.2-mysql php7.2-gd php7.2-xml php7.2-cli php7.2-zip

# E: Unable to locate package php7.2-mcrypt
# https://stackoverflow.com/questions/48275494/issue-in-installing-php7-2-mcrypt

crudini --set /etc/php/7.2/apache2/php.ini PHP file_uploads On
crudini --set /etc/php/7.2/apache2/php.ini PHP allow_url_fopen On
crudini --set /etc/php/7.2/apache2/php.ini PHP short_open_tag On
crudini --set /etc/php/7.2/apache2/php.ini PHP memory_limit 512M
crudini --set /etc/php/7.2/apache2/php.ini PHP upload_max_filesize 128M
crudini --set /etc/php/7.2/apache2/php.ini PHP max_execution_time 3600
