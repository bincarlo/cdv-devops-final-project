variable "resource_base_name" {
  type        = string
  description = "Resource base name"
}

variable "environment" {
  type        = string
  description = "Environment type"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "vm_label" {
  type        = string
  description = "Additional virtual machine type/label"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "instances" {
  type        = number
  description = "VM count"
}

variable "vm_admin_password" {
  type        = string
  description = "Virtual machine admin passowrd"
}

variable "vm_image_publisher" {
  type        = string
  description = "Virtual machine source image publisher"
}

variable "vm_image_offer" {
  type        = string
  description = "Virtual machine source image offer"
}

variable "vm_image_sku" {
  type        = string
  description = "Virtual machine source image SKU"
}

variable "vm_image_version" {
  type        = string
  description = "Virtual machine source image version"
}

variable "subnet_id" {
  type        = string
  description = "Subnet Id"
}

variable "nsg_id" {
  type        = string
  description = "Network security group Id"
}

variable "create_public_ip" {
  type        = bool
  description = "Should Public IP be created"
}

variable "create_as" {
  type        = bool
  description = "Should be placed in Availability Set"
}

variable "availability_set_id" {
  type        = string
  description = "Availability set Id"
  default     = null
}
