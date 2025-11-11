#!/bin/bash

# Delete the Terraform resources

terraform destroy -auto-approve

RESOURCE_GROUP_NAME="terraform-backend-rg"

# Delete the resource group for the backend storage account and all its resources
az group delete --name "$RESOURCE_GROUP_NAME" --yes --no-wait

echo "Deletion initiated for resource group: $RESOURCE_GROUP_NAME"

 