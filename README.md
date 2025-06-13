# Azure Linux VM Terraform Deployment (SandBox)

This repository contains Terraform configuration files and scripts to provision a Linux Virtual Machine and supporting Azure infrastructure.

## Project Structure

- `main.tf` – Defines Azure resources: resource group, virtual network, subnet, network security group, public IP, network interface, and Linux VM.
- `providers.tf` – Specifies the required Azure provider and subscription.
- `backend.tf` – Configures remote state storage using Azure Blob Storage.
- `script/backend-script.sh` – Bash script to create the Azure storage backend for Terraform state.
- `script/delete-backend.sh` – Bash script to delete the backend resource group and all its resources.
- `.gitignore` – Ignores Terraform state and lock files.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription with sufficient permissions

## Setup

### 1. Configure the Backend

Before running Terraform, create the backend storage for remote state:

```sh
cd script
./backend-script.sh
```

Update `backend.tf` with the correct values for:
- `resource_group_name`
- `storage_account_name`
- `container_name`


### 2. Initialize Terraform

```sh
terraform init
```

### 3. Plan and Apply

```sh
terraform plan
terraform apply
```

### 4. Destroy Resources

To remove all resources created by Terraform:

```sh
terraform destroy
```

### 5. Delete Backend Storage (Optional)

To delete the backend storage resource group:

```sh
cd script
./delete-backend.sh
```

## Notes

- The VM is provisioned with SSH key authentication. Ensure your public key exists at `~/.ssh/id_rsa.pub` or update the path in `main.tf`.
- Security group allows SSH (22).
- All resources are created in the specified Azure region.

## License

MIT License