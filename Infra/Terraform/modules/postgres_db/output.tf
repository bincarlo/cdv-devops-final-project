output "postgres_hostname" {
  value = azurerm_postgresql_server.psql_server.name
}

output "postgres_id" {
  value = azurerm_postgresql_server.psql_server.id
}
