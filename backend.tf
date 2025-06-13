terraform {
    backend "azurerm" {
        resource_group_name   = "terraform"
        storage_account_name  = "deentfstate"
        container_name        = "tfstate"
        key                   = "linuxvm.tfstate"
    }
}