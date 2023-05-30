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
