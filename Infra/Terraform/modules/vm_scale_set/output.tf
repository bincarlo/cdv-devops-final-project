output "vmss_id" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.id
}

output "vmss_name" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.name
}

output "vmss_lb_id" {
  value = azurerm_lb.lb.id
}

output "vmss_lb_name" {
  value = azurerm_lb.lb.name
}
