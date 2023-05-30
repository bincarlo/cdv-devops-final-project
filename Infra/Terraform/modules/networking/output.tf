output "bastion_subnet_id" {
  value = azurerm_subnet.bastion_subnet.id
}

output "bastion_nsg_id" {
  value = azurerm_network_security_group.bastion_nsg.id
}

output "main_subnet_id" {
  value = azurerm_subnet.main_subnet.id
}

output "main_nsg_id" {
  value = azurerm_network_security_group.main_nsg.id
}
