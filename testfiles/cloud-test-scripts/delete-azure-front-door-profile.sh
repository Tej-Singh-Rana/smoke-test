#!/bin/bash

# Set the resource group name
RESOURCE_GROUP=$(az group list --query "[0].name" -o tsv)

for i in {1..10}
do
  az afd profile delete \
    -g "$RESOURCE_GROUP" \
    --profile-name profile$i \
    --yes
done
