#!/bin/bash

firewall-cmd --set-default-zone=internal
firewall-cmd --change-interface=eth0

#add sources to ip table
firewall-cmd --zone=internal --add-source=192.168.1.1
firewall-cmd --zone=internal --add-source=192.168.1.11
firewall-cmd --zone=internal --add-source=192.168.1.12
firewall-cmd --zone=internal --add-source=192.168.1.13

# delete services

firewall-cmd --remove-service={mdns,samba-client,dhcpv6-client}

#save changes
firewall-cmd --runtime-to-permanent

# Create service and enable ports for galera-cluster
### 3306 ### For MySQL client connections and State Snapshot Transfer that use the mysqldump method.
### 4567 ### For Galera Cluster replication traffic. Multicast replication uses both UDP transport and TCP on this port.
### 4568 ### For Incremental State Transfer.
### 4444 ### For all owther State Snapshot Transfer.

firewall-cmd --new-service="galera-cluster" --permanent

cat > /etc/firewalld/services/galera-cluster.xml << EOF
<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>Galera</short>
  <description>Galera</description>
  <port protocol="tcp" port="3306"/>
  <port protocol="tcp" port="4567"/>
  <port protocol="udp" port="4567"/>
  <port protocol="tcp" port="4568"/>
  <port protocol="tcp" port="4444"/>
</service>
EOF

# Reload firewall to apply the changes
firewall-cmd --reload

# Enable Galera Service

firewall-cmd --add-service=galera-cluster --zone=internal --permanent


