
#!/bin/bash 

resource_group=$(az group list --query "[0].name" -o tsv)

for i in {1..10}
do
  az afd profile create \
    -g "$resource_group" \
    --profile-name profile$i \
    --sku Standard_AzureFrontDoor
done
