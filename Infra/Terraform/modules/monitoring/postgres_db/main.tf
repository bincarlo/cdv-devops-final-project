resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_postgres" {
  name                       = "${var.resource_base_name}-${var.environment}-mds-postgres"
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
    category = "PostgreSQLLogs"
    retention_policy {
      enabled = true
      days    = 1
    }
  }
}

resource "azurerm_monitor_metric_alert" "metric_alert_postgres_warning" {
  name                = "[WARN] DB ${var.service_name} storage capacity less then .15"
  resource_group_name = var.resource_group_name
  scopes              = [var.service_id]
  frequency           = "PT1M"
  severity            = "2"
  window_size         = "PT5M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/servers"
    metric_name      = "storage_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 85
  }

  action {
    action_group_id = var.ag_warning
  }
}

resource "azurerm_monitor_metric_alert" "metric_alert_postgres_error" {
  name                = "[ERR] DB ${var.service_name} storage capacity less then .10"
  resource_group_name = var.resource_group_name
  scopes              = [var.service_id]
  frequency           = "PT1M"
  severity            = "1"
  window_size         = "PT5M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/servers"
    metric_name      = "storage_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90
  }

  action {
    action_group_id = var.ag_critical
  }
}

resource "azurerm_monitor_metric_alert" "metric_alert_postgres_critical" {
  name                = "[CRIT] DB ${var.service_name} storage capacity less then .05"
  resource_group_name = var.resource_group_name
  scopes              = [var.service_id]
  frequency           = "PT1M"
  severity            = "0"
  window_size         = "PT5M"
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/servers"
    metric_name      = "storage_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 95
  }

  action {
    action_group_id = var.ag_critical
  }
}
