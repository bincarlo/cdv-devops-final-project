resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_network_security_group" {
  name                       = "${var.resource_base_name}-${var.environment}-mds-nsg"
  target_resource_id         = var.service_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
    retention_policy {
      enabled = true
      days    = 1
    }
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
    retention_policy {
      enabled = true
      days    = 1
    }
  }
}
