variable "subscription_id" {
  description = "The Azure Subscription ID"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the VM"
  type        = string
  sensitive   = true
}