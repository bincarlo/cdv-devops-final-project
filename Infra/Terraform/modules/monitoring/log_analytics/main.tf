resource "azurerm_log_analytics_workspace" "la" {
  name                = "${var.resource_base_name}-monitoring-la"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  tags                = var.tags
}

resource "azurerm_monitor_action_group" "ag_warning" {
  name                = "${var.resource_base_name}-ag-warning"
  resource_group_name = azurerm_log_analytics_workspace.la.resource_group_name
  short_name          = "mail-warn"

  email_receiver {
    name                    = "${var.resource_base_name}-mail-warning"
    email_address           = var.alert_notification_mail
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_action_group" "ag_critical" {
  name                = "${var.resource_base_name}-ag-critical"
  resource_group_name = azurerm_log_analytics_workspace.la.resource_group_name
  short_name          = "mail-crit"

  email_receiver {
    name                    = "${var.resource_base_name}-mail-critical"
    email_address           = var.alert_notification_mail
    use_common_alert_schema = true
  }
}
