# Create Resource Group
resource "azurerm_resource_group" "linus" {
  name     = "Linus-rg"
  location = "West US"
}

# Create Virtual Network
resource "azurerm_virtual_network" "linus" {
  name                = "linus-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.linus.location
  resource_group_name = azurerm_resource_group.linus.name
}

# Create Subnet
resource "azurerm_subnet" "linus" {
  name                 = "linus-vm-subnet"
  resource_group_name  = azurerm_resource_group.linus.name
  virtual_network_name = azurerm_virtual_network.linus.name
  address_prefixes     = ["10.0.2.0/24"]


}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "linus" {
  name                = "linus-sub-nsg"
  resource_group_name = azurerm_resource_group.linus.name
  location            = azurerm_resource_group.linus.location

  dynamic "security_rule" {
    for_each = var.inbound_security_rule
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

}

# Associate NSG to Subnet
resource "azurerm_subnet_network_security_group_association" "linus" {
  network_security_group_id = azurerm_network_security_group.linus.id
  subnet_id                 = azurerm_subnet.linus.id

}

# Create Public IP
resource "azurerm_public_ip" "linus" {
  name                = "linus-ip"
  location            = azurerm_resource_group.linus.location
  resource_group_name = azurerm_resource_group.linus.name
  allocation_method   = "Static"
}

# Create Network Interface
resource "azurerm_network_interface" "linus" {
  name                = "linus-nic"
  location            = azurerm_resource_group.linus.location
  resource_group_name = azurerm_resource_group.linus.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.linus.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linus.id
  }
}

# Create Linux VM
resource "azurerm_linux_virtual_machine" "linus" {
  name                = "linus-vm"
  resource_group_name = azurerm_resource_group.linus.name
  location            = azurerm_resource_group.linus.location
  size                = "Standard_B4ms"
  admin_username      = "linus"
  network_interface_ids = [
    azurerm_network_interface.linus.id,
  ]

  admin_password                  = var.admin_password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "linus-os-disk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "ubuntu-pro"
    version   = "latest"
  }
}

# Add custom script for RDP access (Optional)
resource "azurerm_virtual_machine_extension" "script" {
  name                 = "CustomScriptExtension"
  virtual_machine_id   = azurerm_linux_virtual_machine.linus.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/MMuyideen/azure-linux-vm-terraform/refs/heads/main/script/rdp.sh"],
        "commandToExecute": "bash rdp.sh"
    }
  SETTINGS

}
