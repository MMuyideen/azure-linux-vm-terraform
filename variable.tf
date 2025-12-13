variable "subscription_id" {
  description = "The Azure Subscription ID"
  type        = string
}

variable "inbound_security_rule" {
  description = "List of inbound security rule we want to configure"
  type = list(object({
    name                   = string
    priority               = string
    destination_port_range = string
  }))
}

variable "admin_password" {
  description = "The admin password for the VM"
  type        = string
  sensitive   = true
}
