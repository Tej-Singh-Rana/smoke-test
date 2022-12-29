#!/bin/bash


kubectl delete po -n alpha --force sonata

kubectl delete po -n alpha --force triton

kubectl get po -n alpha

