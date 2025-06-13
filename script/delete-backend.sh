#!/bin/bash

RESOURCE_GROUP_NAME="terraform-backend-rg"

# Replace with your actual resource group name used in backend-script.sh
RESOURCE_GROUP_NAME="your-backend-resource-group"

# Delete the resource group and all its resources
az group delete --name "$RESOURCE_GROUP_NAME" --yes --no-wait

echo "Deletion initiated for resource group: $RESOURCE_GROUP_NAME"