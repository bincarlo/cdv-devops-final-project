variable "prefix" {
  type        = string
  description = "Team prefix"
}

variable "application" {
  type        = string
  description = "Applcation name"
  default     = "sales"
}

variable "environment" {
  type        = string
  description = "Environment type"
}

variable "owner" {
  type        = string
  description = "Owner email address"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "vm_admin_password" {
  type        = string
  description = "Virtual machine admin password"
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

variable "db_admin_user" {
  type        = string
  description = "DB admin login"
}

variable "db_admin_password" {
  type        = string
  description = "DB admin password"
}

variable "notification_mail" {
  type        = string
  description = "Mail address for autoscaling notifications"
  default     = null
}

locals {
  resource_base_name = "${var.prefix}-${var.application}"

  default_tags = {
    "application" = "${var.application}",
    "owner"       = "${var.owner}"
    "realm"       = "${var.prefix}"
  }
}
