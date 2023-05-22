variable "environment" {}

variable "password" {}

variable "access_key" {}

variable "blob" {}


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
  name     = "training_cicd_analytics_aas_${var.environment}"
  location = "westeurope"
}


resource "azurerm_sql_server" "sqlserver" {
  name                         = "training-cicd-analytics-aas-${var.environment}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "azuredevops_${var.environment}"
  administrator_login_password = var.password
}

resource "azurerm_sql_database" "sqldb" {
  name                             = "AdventureWorksDW2022"
  resource_group_name              = azurerm_sql_server.sqlserver.resource_group_name
  location                         = azurerm_sql_server.sqlserver.location
  server_name                      = azurerm_sql_server.sqlserver.name
  collation                        = "SQL_Latin1_General_CP1_CI_AS"
  requested_service_objective_name = "Basic"
  edition                          = "Basic"
  max_size_bytes                   = 2147483648

  create_mode = "Default"
  import {
    storage_uri                  = "https://csharplie.blob.core.windows.net/databases/AdventureWorksDW2022.bacpac"
    storage_key                  = var.access_key
    storage_key_type             = "StorageAccessKey"
    administrator_login          = "azuredevops_${var.environment}"
    administrator_login_password = var.password
    authentication_type          = "SQL"
    operation_mode               = "Import"
  }
}

resource "azurerm_sql_firewall_rule" "db_fw_az" {
  name                = "Azure Services"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sqlserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_firewall_rule" "db_fw_all" {
  name                = "All IPs"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sqlserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}
