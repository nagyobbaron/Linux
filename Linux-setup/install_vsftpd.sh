#!/bin/bash

function_install () {
# Install vsftpd service
apt-get update && apt-get install -y vsftpd
	
# Create backup file ( see options details in the backup file)
cp /etc/vsftpd.conf /etc/vsftpd.conf.bak

# Editing the config file
sed -i '/^#/d;s/listen=NO/listen=YES/g;s/listen_ipv6=YES/listen_ipv6=NO/g;s/ssl_enable=NO/ssl_enable=YES/g' /etc/vsftpd.conf && cat >> /etc/vsftpd.conf <<END
write_enable=YES
local_umask=022
chroot_local_user=YES
pasv_enable=Yes
pasv_min_port=10000
pasv_max_port=10100
allow_writeable_chroot=YES
END

systemctl restart vsftpd.service
}

# Run script with root user

if ! [ $(id -u) = 0 ]; then
   echo "I am not root!"
   exit 1
fi

# Verify arguments
#   if{1} - no argument exists
#   if{2} - argument[1] = --install
#   if{3} - argument[1] = --adduser AND argument[2] NOT EMPTY

if [[ $1 == "" ]]; then
cat <<END
### Use the script with arguments ###
    1. --install ( script will install and configure the service)
    2. --adduser <username> ( add ftpsuer)
END
exit 0

elif [[ $1 == "--install" ]]; then
    #function_install
    echo install done

elif [[ $1 == "--adduser" && $2 != "" ]]; then
    echo adding user "$2"
    useradd -m "$2"
    passwd "$2"
    bash -c "echo FTP TESTING > /home/$2/FTP-TEST"
fi

