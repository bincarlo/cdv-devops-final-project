terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.58.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "cdv-sales-tfstate-rg"
    storage_account_name = "cdvtfstatesaleskk"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
