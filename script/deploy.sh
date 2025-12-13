#!/bin/bash

# Variables
RESOURCE_GROUP_NAME="terraform-backend-rg"
LOCATION="eastus"
STORAGE_ACCOUNT="deenterraformstate"
CONTAINER_NAME="tfstate"

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create storage account
az storage account create \
    --name $STORAGE_ACCOUNT \
    --resource-group $RESOURCE_GROUP_NAME \
    --location $LOCATION \
    --sku Standard_LRS

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list \
    --resource-group $RESOURCE_GROUP_NAME \
    --account-name $STORAGE_ACCOUNT \
    --query "[0].value" -o tsv)

# Create blob container
az storage container create \
    --name $CONTAINER_NAME \
    --account-name $STORAGE_ACCOUNT \
    --account-key $ACCOUNT_KEY

echo "Resource group, storage account, and container created."

# Create Terraform Resources

terraform init -upgrade
terraform apply -auto-approve