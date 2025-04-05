#!/bin/bash

kubectl get node -o jsonpath='{.items[0].spec.podCIDR}' > /root/pod-cidr.txt
