resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_base_name}-${var.environment}-rg"
  location = var.location
  tags     = var.tags
}
