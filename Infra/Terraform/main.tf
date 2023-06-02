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

module "tin-army-scale-set" {
  source = "./modules/vm_scale_set"

  instances = 2

  resource_base_name          = local.resource_base_name
  environment                 = var.environment
  location                    = var.location
  resource_group_name         = module.main_resource_group.resource_group_name
  vm_admin_password           = var.vm_admin_password
  vm_image_publisher          = var.vm_image_publisher
  vm_image_offer              = var.vm_image_offer
  vm_image_sku                = var.vm_image_sku
  vm_image_version            = var.vm_image_version
  make_zone_redundant         = true
  subnet_id                   = module.networking.main_subnet_id
  nsg_id                      = module.networking.main_nsg_id
  autoscale_notification_mail = var.autoscale_notification_mail
  tags                        = module.main_resource_group.tags

  postgres_user     = join("", [var.db_admin_user, "@", module.db.postgres_hostname])
  postgres_password = var.db_admin_password
  postgres_host     = join("", [module.db.postgres_hostname, ".postgres.database.azure.com"])


  depends_on = [
    module.db
  ]
}

module "db" {
  source = "./modules/postgres_db"

  resource_base_name  = local.resource_base_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.main_resource_group.resource_group_name
  db_admin_user       = var.db_admin_user
  db_admin_password   = var.db_admin_password
  tags                = module.main_resource_group.tags
}
