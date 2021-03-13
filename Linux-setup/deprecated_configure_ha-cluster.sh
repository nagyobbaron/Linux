#!/bin/bash

# Install dependencies and configure user

apt-get install pacemaker pcs resource-agents
apt-get install firewalld
echo 'hacluster:StiaNshe12!' | chpasswd

# Configure firewall

firewall-cmd --set-default-zone=internal
firewall-cmd --runtime-to-permanent
firewall-cmd --remove-service={mdns,samba-client,dhcpv6-client} --permanent --zone=internar
firewall-cmd --permanent --add-service=high-availability
firewall-cmd --reload

# Enable and start pcsd service

systemctl enable pcsd --now

# authorize nodes
pcs cluster auth 172.16.1.101 172.16.1.102 -u hacluster -p StiaNshe12!

# create cluster

pcs cluster setup --name ha-cluster-frontend 172.16.1.101 172.16.1.102 --force
pcs cluster start --all

# Disable STONITH

pcs property set stonith-enabled=false

# Ignore QUORUM policy

pcs property set no-quorum-policy=ignore
