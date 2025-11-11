# Azure Linux VM Terraform Deployment (Sandbox)

This repository contains Terraform configuration and helper scripts to provision a Linux virtual machine and the required Azure networking and supporting resources.

The configuration is intentionally small and aimed at learning, testing, or sandbox environments. Do not use these exact defaults in production without reviewing security and sizing choices.

## Repository structure

- `main.tf` - Primary Terraform configuration (resource group, VNet, subnet, NSG, public IP, NIC, Linux VM, and a custom script extension).
- `providers.tf` - Terraform provider configuration and required provider versions.
- `backend.tf` - Terraform backend configuration for remote state (this file is in the repo but requires values to be populated).
- `terraform.tfvars` - Example variable values (DO NOT commit secrets in real projects).
- `variable.tf` - Variable definitions used by the configuration.
- `script/` - Helper bash scripts used for backend creation and VM setup:
	- `deploy.sh` - create backend storage (used for remote state)
	- `destroy.sh` - delete backend resources created by `deploy.sh`
	- `rdp.sh` - script executed on the VM via Custom Script Extension (enables xRDP and related packages)

## Prerequisites

- Terraform >= 1.0
- Azure CLI (az)
- An Azure subscription with rights to create resource groups, storage accounts, and compute resources

## Quick start

1. Clone the repository and change into it:

```bash
git clone https://github.com/MMuyideen/azure-linux-vm-terraform.git
cd azure-linux-vm-terraform
```

2. Create backend resources and deploy (the scripts include Terraform commands)

Before running the scripts, edit `terraform.tfvars` and set `subscription_id` and `admin_password` (or export variables/flags you prefer). The repository ships example values for demonstration only.

Then run the deploy script from the project root:

```bash
./script/deploy.sh
```

What `deploy.sh` does (summary):
- Creates an Azure resource group and a storage account/container intended for Terraform remote state (resource names are defined inside the script).
- Runs `terraform init -upgrade` and `terraform apply -auto-approve` in the repository root to provision the VM and supporting resources.

If you prefer to manage the backend manually, update `backend.tf` with the correct `resource_group_name`, `storage_account_name`, and `container_name` before running `terraform init` and the scripts.

Destroying the resources

The repository also includes a convenience script to destroy the stack and remove backend resources. The script will run Terraform destroy and then delete the backend resource group created by `deploy.sh`.

```bash
./script/destroy.sh
```

What `destroy.sh` does (summary):
- Runs `terraform destroy -auto-approve` in the repository root to tear down resources created by Terraform.
- Deletes the backend resource group (the script contains the RG name it deletes).

## Scripts

- `script/deploy.sh` - Creates the backend resource group, storage account and blob container (names are defined inside the script). After creating those resources it runs the following Terraform commands from the repository root:
	- `terraform init -upgrade`
	- `terraform apply -auto-approve`
	Make sure `terraform.tfvars` is populated with `subscription_id` and `admin_password` before running this script.

- `script/destroy.sh` - Runs `terraform destroy -auto-approve` to remove the Terraform-managed resources, then deletes the backend resource group used for remote state (the RG name is contained in the script).

- `script/rdp.sh` - This is the script executed on the Linux VM via the Custom Script Extension. It installs and configures xRDP and a lightweight desktop (XFCE) so you can RDP into the VM. The script also enables UFW rules for port 3389. `main.tf` references the raw GitHub URL for this file; if you edit `script/rdp.sh`, update the URL used in the VM extension settings or host it where the VM can access it.

## Variables

- `subscription_id` (set in `terraform.tfvars`)
- `admin_password` (set in `terraform.tfvars`) — currently the configuration uses password auth for the sake of using desktop environment; consider switching to SSH key auth if desktop is not needed or for production.

All variables are declared in `variable.tf`.

## Security notes

- Do not store secrets (passwords, service principal secrets) in plaintext in the repository. Use environment variables or a secrets manager.
- The example `terraform.tfvars` in this repository contains a sample value for `admin_password`. Replace it before provisioning and remove local copies after use.
- The NSG in `main.tf` opens SSH (22), HTTP (80), HTTPS (443) and RDP (3389) to `*` for learning purposes only. Restrict source IP ranges for production.

## Troubleshooting

- If `terraform init` fails because the backend settings are missing, edit `backend.tf` and populate `resource_group_name`, `storage_account_name`, and `container_name` with the values created by `script/deploy.sh`.
- If the custom script extension fails on the VM, check the VM extension status in the Azure portal and review the extension logs under `/var/log/azure` on the VM.

## Tips / Next steps

- Switch to SSH public-key authentication for the VM (`azurerm_linux_virtual_machine` supports `admin_ssh_key`).
- Consider parameterizing image SKU and size to make the module reusable.
- Add automated tests or a small CI job to run `terraform validate` and `terraform fmt`.

## License

MIT License

## Acknowledgements

This repo is a small learning/sandbox example for deploying a Linux VM on Azure with Terraform. Use with care.