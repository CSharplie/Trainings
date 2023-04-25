
variable "environment" {
  default = "dev"
}

variable "password" {
  default = ""
}

variable "tenant_id" {
  default = ""
}

variable "spn_id" {
  default = ""
}

terraform {
  backend "azurerm" {
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.87.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "training_cicd_analytics_${var.environment}"
  location = "westeurope"
}

module "server_dev" {
  source         = "./modules/server"
  resource_group = azurerm_resource_group.rg
  environment    = var.environment
  password       = var.password
  tenant_id      = var.tenant_id
  spn_id         = var.spn_id
}



