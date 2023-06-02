output "la_id" {
  value = azurerm_log_analytics_workspace.la.id
}

output "la_name" {
  value = azurerm_log_analytics_workspace.la.name
}

output "ag_warning" {
  value = azurerm_monitor_action_group.ag_warning.id
}

output "ag_critical" {
  value = azurerm_monitor_action_group.ag_critical.id
}
