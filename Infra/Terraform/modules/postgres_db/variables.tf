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

variable "db_admin_user" {
  type        = string
  description = "DB admin login"
}

variable "db_admin_password" {
  type        = string
  description = "DB admin password"
}
