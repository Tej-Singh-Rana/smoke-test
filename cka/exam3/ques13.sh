#!/bin/bash

helm install --generate-name /root/new-version

helm uninstall webpage-server-01 -n default

helm ls
