#!/bin/bash

#add repokeyserver
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8

#add repository for mariadb
sudo add-apt-repository 'deb [arch=amd64] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.4/ubuntu bionic main'

sudo apt update

#install mariadb
sudo apt install mariadb-server

# Create galera configuration

touch /etc/mysql/conf.d/galera.cnf

cat > /etc/mysql/conf.d/galera.cnf << EOF
[mysqld]
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
bind-address=0.0.0.0

# Galera Provider Configuration
wsrep_on=ON
wsrep_provider=/usr/lib/galera/libgalera_smm.so

# Galera Cluster Configuration
wsrep_cluster_name="iulian_test_cluster"
wsrep_cluster_address="gcomm://192.168.1.11,192.168.1.12,192.168.1.13"

# Galera Synchronization Configuration
wsrep_sst_method=rsync

# Galera Node Configuration
wsrep_node_address="$(ip -4 addr | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127)"
wsrep_node_name="$(hostname)"
EOF

systemctl stop mysql

if [ $(hostname -I) = "192.168.1.11" ] ; then
	galera_new_cluster
else
	systemctl start mysql
fi
