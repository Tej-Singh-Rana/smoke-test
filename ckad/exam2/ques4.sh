#!/bin/bash

kubectl create ingress ingress --rule="ckad-mock-exam-solution.com/video*=my-video-service:8080" --dry-run=client -oyaml > /root/ques4-ingress.yaml


kubectl apply -f /root/ques4-ingress.yaml


