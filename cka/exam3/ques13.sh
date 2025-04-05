#!/bin/bash

helm install --generate-name ./new-version

helm uninstall webpage-server-01 -n default
