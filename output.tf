output "vm_public_ip" {
  description = "The public IP address of the VM"
  value       = azurerm_public_ip.linus.ip_address
}

output "SSh_Command" {
  value = "ssh ${azurerm_linux_virtual_machine.linus.admin_username}@${azurerm_public_ip.linus.ip_address}"
}