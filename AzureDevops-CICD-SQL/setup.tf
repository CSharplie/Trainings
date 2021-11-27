
terraform {
    required_providers {
        azurerm = {
            source                              = "hashicorp/azurerm"
            version                             = "~> 2.47.0"
        }
    }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}


resource "azurerm_resource_group" "rg" {
    name                                        = "training_cicd_analytics"
    location                                    = "westeurope"
}

module "server_dev" {
    source                                      = "./modules/server"
    resource_group                              = azurerm_resource_group.rg
    environment                                 = "dev"
    password                                    = "pzcRYVqm*s9ZYVrGuPXHZuPE"
}

module "server_prd" {
    source                                      = "./modules/server"
    resource_group                              = azurerm_resource_group.rg
    environment                                 = "dev"
    password                                    = "mF@DdWxaa#3^Gzk*%BCGfU8g"
}



