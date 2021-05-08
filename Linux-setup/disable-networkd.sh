#!/bin/bash

apt-get update
apt-get install ifupdown
ifdown --force eth0 eth1 eth2 lo && ifup -a
systemctl unmask networking
systemctl enable networking --now
systemctl stop systemd-networkd.socket systemd-networkd.service
systemctl disable systemd-networkd.socket systemd-networkd.service
systemctl mask systemd-networkd.socket systemd-networkd.service
