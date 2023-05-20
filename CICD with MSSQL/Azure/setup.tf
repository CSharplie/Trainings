
variable "environment" {
  default = "dev"
}

variable "password" {
  default = ""
}

variable "spn_azuredevops" {
  default = ""
}

variable "spn_github" {
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

data "azuread_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "training_cicd_analytics_${var.environment}"
  location = "westeurope"
}

resource "azurerm_key_vault" "key_vault" {
  name                        = "akv-csharplie-train-${var.environment}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azuread_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  access_policy {
    tenant_id          = data.azuread_client_config.current.tenant_id
    object_id          = var.spn_github
    secret_permissions = ["get", "list", "set", "delete", "recover", "purge"]
  }

  access_policy {
    tenant_id          = data.azuread_client_config.current.tenant_id
    object_id          = var.spn_azuredevops
    secret_permissions = ["get", "list", "set", "delete"]
  }
}

resource "azurerm_key_vault_secret" "akv_sql_password" {
  name         = "sql-password"
  value        = var.password
  key_vault_id = azurerm_key_vault.key_vault.id
}

module "sql_server" {
  source         = "./modules/server"
  resource_group = azurerm_resource_group.rg
  environment    = var.environment
  password       = var.password
  spn            = var.spn_azuredevops
}



