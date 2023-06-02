resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_vm_scale_set" {
  name                       = "${var.resource_base_name}-${var.environment}-mds-vm-scale-set"
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
}

resource "azurerm_monitor_metric_alert" "metric_alert_vmss_warning" {
  name                = "[WARN] Average CPU load above .80 on VMSS ${var.service_name}"
  resource_group_name = var.resource_group_name
  scopes              = [var.service_id]
  frequency           = "PT5M"
  severity            = "2"
  window_size         = "PT5M"
  tags                = var.tags

  criteria {
    metric_namespace = "microsoft.compute/virtualmachinescalesets"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = var.ag_warning
  }
}

resource "azurerm_monitor_metric_alert" "metric_alert_vmss_error" {
  name                = "[ERR] Average CPU load above .90 on VMSS ${var.service_name}"
  resource_group_name = var.resource_group_name
  scopes              = [var.service_id]
  frequency           = "PT5M"
  severity            = "1"
  window_size         = "PT5M"
  tags                = var.tags

  criteria {
    metric_namespace = "microsoft.compute/virtualmachinescalesets"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90
  }

  action {
    action_group_id = var.ag_critical
  }
}

resource "azurerm_monitor_metric_alert" "metric_alert_vmss_availability" {
  name                = "[CRIT] VMSS ${var.service_name} is unavailabile"
  resource_group_name = var.resource_group_name
  scopes              = [var.service_id]
  frequency           = "PT1M"
  severity            = "0"
  window_size         = "PT1M"
  tags                = var.tags

  criteria {
    metric_namespace = "microsoft.compute/virtualmachinescalesets"
    metric_name      = "VmAvailabilityMetric"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 1
  }

  action {
    action_group_id = var.ag_critical
  }
}
