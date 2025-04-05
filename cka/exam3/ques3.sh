#!/bin/bash

kubectl create configmap app-config -n cm-namespace \
  --from-literal=ENV=production \
  --from-literal=LOG_LEVEL=info

kubectl set env deployment/cm-webapp -n cm-namespace \
  --from=configmap/app-config
