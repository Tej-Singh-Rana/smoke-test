#!/bin/bash


kubectl logs dev-pod-dind-878516 -c log-x | grep WARNING > /opt/dind-878516_logs.txt

cat /opt/dind-878516_logs.txt

