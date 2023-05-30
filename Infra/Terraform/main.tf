module "main_resource_group" {
  source = "./modules/resource_group"

  resource_base_name = local.resource_base_name
  environment        = var.environment
  location           = var.location

  tags = merge(
    local.default_tags,
    tomap({
      "environment" = "${var.environment}"
    })
  )
}

module "networking" {
  source = "./modules/networking"

  resource_base_name  = local.resource_base_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.main_resource_group.resource_group_name
  tags                = module.main_resource_group.tags
}

module "bastion" {
  source = "./modules/virtual_machine"

  count = 1

  vm_label            = "bastion"
  resource_base_name  = local.resource_base_name
  environment         = var.environment
  location            = var.location
  instances           = count.index
  resource_group_name = module.main_resource_group.resource_group_name
  vm_admin_password   = var.vm_admin_password
  vm_image_publisher  = var.vm_image_publisher
  vm_image_offer      = var.vm_image_offer
  vm_image_sku        = var.vm_image_sku
  vm_image_version    = var.vm_image_version

  subnet_id        = module.networking.bastion_subnet_id
  nsg_id           = module.networking.bastion_nsg_id
  create_public_ip = true
  create_as        = false

  tags = module.main_resource_group.tags
}

module "application_nodes" {
  source = "./modules/virtual_machine"

  count = 2

  vm_label            = "tin-soldier"
  resource_base_name  = local.resource_base_name
  environment         = var.environment
  location            = var.location
  instances           = count.index
  resource_group_name = module.main_resource_group.resource_group_name
  vm_admin_password   = var.vm_admin_password
  vm_image_publisher  = var.vm_image_publisher
  vm_image_offer      = var.vm_image_offer
  vm_image_sku        = var.vm_image_sku
  vm_image_version    = var.vm_image_version

  subnet_id        = module.networking.main_subnet_id
  nsg_id           = module.networking.main_nsg_id
  create_public_ip = false
  create_as        = false

  tags = module.main_resource_group.tags
}
