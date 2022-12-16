#!/bin/bash

kubectl run messaging --image=redis:alpine -l tier=msg

