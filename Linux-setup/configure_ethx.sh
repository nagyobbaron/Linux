#!/bin/bash

sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"/g' /etc/default/grub
update-grub

# sed -i "s/$(netstat -i | grep ens | cut -d" " -f 1)/eth0/g" /etc/netplan/00-installer-config.yaml
