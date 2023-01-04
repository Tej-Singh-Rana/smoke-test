#!/bin/bash

netstat -natulp | grep 8088

systemctl list-units  -t service --state active | grep -i openlitespeed

systemctl stop lshttpd

systemctl disable lshttpd

apt list --installed | grep openlitespeed

apt remove openlitespeed -y

echo "##################################"
echo " " 
echo "Checking the removed port 8088" 

netstat -natulp | grep 8088

