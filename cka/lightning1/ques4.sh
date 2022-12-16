#!/bin/bash

kubectl create deployment  nginx-deploy --image=nginx:1.16

kubectl set image deployment/nginx-deploy nginx=nginx:1.17 --record


