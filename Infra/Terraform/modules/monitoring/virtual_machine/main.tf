resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_virtual_machine" {
  name                       = "${var.resource_base_name}-${var.environment}-mds-vm"
  target_resource_id         = var.service_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 1
    }
  }

  # enabled_log {
  #   category = "SoftwareUpdates" #TOCHECK
  #   retention_policy {
  #     enabled = true
  #     days    = 1
  #   }
  # }
}

resource "azurerm_monitor_metric_alert" "metric_alert_vm_warning" {
  name                = "[WARN] Average CPU load above .80 on VM ${var.service_name}"
  resource_group_name = var.resource_group_name
  scopes              = [var.service_id]
  frequency           = "PT5M"
  severity            = "2"
  window_size         = "PT5M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = var.ag_warning
  }
}

resource "azurerm_monitor_metric_alert" "metric_alert_vm_critical" {
  name                = "[CRIT] Average CPU load above .90 on VM ${var.service_name}"
  resource_group_name = var.resource_group_name
  scopes              = [var.service_id]
  frequency           = "PT5M"
  severity            = "1"
  window_size         = "PT5M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90
  }

  action {
    action_group_id = var.ag_critical
  }
}
