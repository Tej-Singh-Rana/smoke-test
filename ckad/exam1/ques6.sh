#!/bin/bash

kubectl expose deployment redis --port=6379 --name messaging-service --namespace marketing

