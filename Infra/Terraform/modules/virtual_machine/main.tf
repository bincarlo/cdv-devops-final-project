resource "azurerm_network_interface" "nic" {
  name                = "${var.resource_base_name}-${var.environment}-${var.vm_label}-nic${var.instances}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "external"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = var.create_public_ip ? azurerm_public_ip.pip[0].id : null
  }
}

resource "azurerm_public_ip" "pip" {
  count               = var.create_public_ip ? 1 : 0
  name                = "${var.resource_base_name}-${var.environment}-${var.vm_label}-vm${var.instances}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                = "${var.resource_base_name}-${var.environment}-${var.vm_label}-vm${var.instances}"
  resource_group_name = azurerm_network_interface.nic.resource_group_name
  location            = azurerm_network_interface.nic.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids           = [azurerm_network_interface.nic.id]
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false
  tags                            = var.tags

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = var.nsg_id
}
