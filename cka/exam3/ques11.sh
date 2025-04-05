#!/bin/bash

echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
echo 'net.bridge.bridge-nf-call-iptables = 1' >> /etc/sysctl.conf
sysctl -p
sysctl net.ipv4.ip_forward
sysctl net.bridge.bridge-nf-call-iptables

