resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                 = "${var.resource_base_name}-${var.environment}-vmss"
  resource_group_name  = var.resource_group_name
  location             = var.location
  sku                  = "Standard_B1s"
  instances            = var.instances
  computer_name_prefix = "${var.resource_base_name}-${var.environment}-vmss-tin-soldier-"
  tags                 = var.tags

  admin_username                  = "azureuser"
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false

  zone_balance = var.make_zone_redundant ? true : false
  zones        = var.make_zone_redundant ? ["1", "2"] : null

  # custom_data = filebase64("${path.module}/setup.sh")
  custom_data = base64encode(local.custom_data)

  health_probe_id = azurerm_lb_probe.lb_probe.id

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  network_interface {
    name                      = "${var.resource_base_name}-${var.environment}-vmss-nic"
    primary                   = true
    network_security_group_id = var.nsg_id
    ip_configuration {
      name      = "${var.resource_base_name}-${var.environment}-vmss-ip-conf"
      subnet_id = var.subnet_id
      primary   = true

      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.lb_backend_pool.id
      ]
    }
  }

  boot_diagnostics {}

  depends_on = [
    azurerm_lb_rule.lb_rule
  ]
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.resource_base_name}-${var.environment}-lb-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_lb" "lb" {
  name                = "${var.resource_base_name}-${var.environment}-lb"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  tags                = var.tags

  frontend_ip_configuration {
    name                 = "${var.resource_base_name}-${var.environment}-lb-frontend-ip-conf"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  name            = "${var.resource_base_name}-${var.environment}-lb-backend-pool"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "lb_probe" {
  name                = "${var.resource_base_name}-${var.environment}-lb-probe"
  loadbalancer_id     = azurerm_lb.lb.id
  port                = "80"
  protocol            = "Http"
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "lb_rule" {
  name                           = "${var.resource_base_name}-${var.environment}-lb-rule"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.lb_probe.id

  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.lb_backend_pool.id
  ]
}

resource "azurerm_monitor_autoscale_setting" "vmss_autoscale" {
  name                = "${var.resource_base_name}-${var.environment}-vmss-autoscale"
  resource_group_name = azurerm_linux_virtual_machine_scale_set.vmss.resource_group_name
  location            = azurerm_linux_virtual_machine_scale_set.vmss.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.vmss.id

  profile {
    name = "${var.resource_base_name}-${var.environment}-vmss-autoscale-default-profile"

    capacity {
      default = var.instances <= 2 ? var.instances : 2
      minimum = var.instances <= 2 ? var.instances : 2
      maximum = 3
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator = true
      custom_emails                      = [var.autoscale_notification_mail]
    }
  }
}
