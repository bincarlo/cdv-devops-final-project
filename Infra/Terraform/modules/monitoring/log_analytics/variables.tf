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

variable "alert_notification_mail" {
  type        = string
  description = "Mail address for alert notifications"
  default     = null
}
