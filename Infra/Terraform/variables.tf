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

locals {
  resource_base_name = "${var.prefix}-${var.application}"

  default_tags = {
    "application" = "${var.application}",
    "owner"       = "${var.owner}"
  }
}
