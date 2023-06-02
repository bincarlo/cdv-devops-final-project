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

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics workspace Id"
}

variable "ag_critical" {
  type        = string
  description = "Critical Action Group Id"
  default     = null
}

variable "ag_warning" {
  type        = string
  description = "Warning Action Group Id"
  default     = null
}

variable "service_id" {
  type        = string
  description = "Service ID"
}

variable "service_name" {
  type        = string
  description = "Service Name"
}
