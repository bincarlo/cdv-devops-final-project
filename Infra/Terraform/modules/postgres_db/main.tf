resource "azurerm_postgresql_server" "psql_server" {
  name                             = "${var.resource_base_name}-${var.environment}-psql-kk0"
  resource_group_name              = var.resource_group_name
  location                         = var.location
  sku_name                         = "B_Gen5_1"
  version                          = "11"
  administrator_login              = var.db_admin_user
  administrator_login_password     = var.db_admin_password
  backup_retention_days            = 7
  geo_redundant_backup_enabled     = false
  storage_mb                       = 5120
  auto_grow_enabled                = true
  ssl_enforcement_enabled          = false
  ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"
  tags                             = var.tags
}

resource "azurerm_postgresql_firewall_rule" "psql_fw_rule" {
  name                = "${var.resource_base_name}-${var.environment}-psql-fw-rule"
  resource_group_name = azurerm_postgresql_server.psql_server.resource_group_name
  server_name         = azurerm_postgresql_server.psql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
