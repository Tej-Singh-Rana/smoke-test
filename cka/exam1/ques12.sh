#!/bin/bash

helm repo ls 

helm ls -A

helm repo update kk-mock1 -n kk-ns

helm upgrade kk-mock1 kk-mock1/nginx -n kk-ns --version=18.1.15

helm ls -n kk-ns
