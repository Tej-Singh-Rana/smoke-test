#!/bin/bash

kubectl create deployment httpd-frontend --image=httpd:2.4-alpine --replicas=3

