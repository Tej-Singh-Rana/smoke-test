#!/bin/bash

sshpass -p "caleston123" ssh -o StrictHostKeyChecking=no bob@node01 "sudo dpkg -i /root/cri-docker_0.3.16.3-0.debian.deb && sudo systemctl enable --now cri-docker.service"



