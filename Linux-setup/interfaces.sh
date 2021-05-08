#!/bin/bash

cat <<EOF > /etc/network/interfaces

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
  address 10.0.0.11
  netmask 255.255.255.0
  dns-nameservers 8.8.8.8

auto eth2
iface eth2 inet manual
  up ip link set dev eth2 up
  down ip link set dev eth2 down
EOF
