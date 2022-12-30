#!/bin/bash

sed -i "s/--authorization-mode=AlwaysAllow/--authorization-mode=Node,RBAC/g" /etc/kubernetes/manifests/kube-apiserver.yaml

