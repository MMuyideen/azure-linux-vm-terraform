resource "azurerm_resource_group" "linus" {
  name     = "Linus-rg"
  location = "West US"
}

resource "azurerm_virtual_network" "linus" {
  name                = "linus-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.linus.location
  resource_group_name = azurerm_resource_group.linus.name
}

resource "azurerm_subnet" "linus" {
  name                 = "linus-vm-subnet"
  resource_group_name  = azurerm_resource_group.linus.name
  virtual_network_name = azurerm_virtual_network.linus.name
  address_prefixes     = ["10.0.2.0/24"]


}

resource "azurerm_network_security_group" "linus" {
  name                = "linus-sub-nsg"
  resource_group_name = azurerm_resource_group.linus.name
  location            = azurerm_resource_group.linus.location

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


}

resource "azurerm_subnet_network_security_group_association" "linus" {
  network_security_group_id = azurerm_network_security_group.linus.id
  subnet_id                 = azurerm_subnet.linus.id

}

resource "azurerm_public_ip" "linus" {
  name                = "linus-ip"
  location            = azurerm_resource_group.linus.location
  resource_group_name = azurerm_resource_group.linus.name
  allocation_method   = "Static"
}


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

resource "azurerm_linux_virtual_machine" "linus" {
  name                = "linus-vm"
  resource_group_name = azurerm_resource_group.linus.name
  location            = azurerm_resource_group.linus.location
  size                = "Standard_B1s"
  admin_username      = "linus"
  network_interface_ids = [
    azurerm_network_interface.linus.id,
  ]

  admin_password                  = var.admin_password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "ubuntu-pro"
    version   = "latest"
  }
}