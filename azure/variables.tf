variable "account_name" {
  description = "The Azure account name"
  type        = string
}

variable "admin_user" {
  description = "The username for the administrator account."
  type        = string
  default     = "azureuser"
}

variable "location" {
  description = "The Azure region to deploy into."
  type        = string
  default     = "eastus"
}

variable "login_email" {
  description = "The email address used to login to OpenCTI."
  type        = string
  default     = "login.email@example.com"
}

variable "os_disk_size" {
  description = "The size of the OS disk (in GB). Minimum recommended is 32."
  type        = number
  default     = 32
}

variable "storage_bucket" {
  description = "Name of the storage bucket."
  type        = string
  default     = "opencti"
}
