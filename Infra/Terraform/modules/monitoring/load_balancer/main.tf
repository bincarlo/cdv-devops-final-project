resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_lb" {
  name                       = "${var.resource_base_name}-${var.environment}-mds-lb"
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

  enabled_log {
    category = "LoadBalancerProbeHealthStatus"
    retention_policy {
      enabled = true
      days    = 1
    }
  }
}

resource "azurerm_monitor_metric_alert" "metric_alert_lb_warning" {
  name                = "[WARN] Healhprobe check percentage below 0.99 on LB ${var.service_name}"
  resource_group_name = var.resource_group_name
  scopes              = [var.service_id]
  frequency           = "PT5M"
  severity            = "2"
  window_size         = "PT5M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.Network/loadBalancers"
    metric_name      = "DipAvailability"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 0.99
  }

  action {
    action_group_id = var.ag_critical
  }
}

resource "azurerm_monitor_metric_alert" "metric_alert_lb_error" {
  name                = "[ERR] Healhprobe check percentage below 0.95 on LB ${var.service_name}"
  resource_group_name = var.resource_group_name
  scopes              = [var.service_id]
  frequency           = "PT5M"
  severity            = "1"
  window_size         = "PT5M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.Network/loadBalancers"
    metric_name      = "DipAvailability"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 0.95
  }

  action {
    action_group_id = var.ag_critical
  }
}

resource "azurerm_monitor_metric_alert" "metric_alert_lb_critical" {
  name                = "[CRIT] Healhprobe check percentage below 0.90 on LB ${var.service_name}"
  resource_group_name = var.resource_group_name
  scopes              = [var.service_id]
  frequency           = "PT5M"
  severity            = "0"
  window_size         = "PT5M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.Network/loadBalancers"
    metric_name      = "DipAvailability"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 0.90
  }

  action {
    action_group_id = var.ag_critical
  }
}
