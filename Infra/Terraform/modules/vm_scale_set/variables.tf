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
  description = "Nubmer of instances deployed"
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
