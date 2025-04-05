#!/bin/bash

kubectl get crds -A | grep -i vertical | awk '{print $1}' > /root/vpa-crds.txt
