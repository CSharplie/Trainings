variable "resource_group" {}
variable "environment" {}
variable "password" {}
variable "spn" {}

data "azuread_client_config" "current" {}

resource "azurerm_sql_server" "server" {
  name                         = "training-cicd-analytics-mssql-${var.environment}"
  resource_group_name          = var.resource_group.name
  location                     = var.resource_group.location
  version                      = "12.0"
  administrator_login          = "azuredevops_${var.environment}"
  administrator_login_password = var.password
}

resource "azurerm_sql_active_directory_administrator" "ad_admin" {
  server_name         = azurerm_sql_server.server.name
  resource_group_name = var.resource_group.name
  login               = "sqladmin"
  tenant_id           = data.azuread_client_config.current.tenant_id
  object_id           = var.spn
}

resource "azurerm_sql_firewall_rule" "db_fw_az" {
  name                = "Azure Services"
  resource_group_name = var.resource_group.name
  server_name         = azurerm_sql_server.server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_firewall_rule" "db_fw_all" {
  name                = "All IPs"
  resource_group_name = var.resource_group.name
  server_name         = azurerm_sql_server.server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

module "database_00" {
  source         = "../../modules/database"
  resource_group = var.resource_group
  environment    = var.environment
  suffix         = "CCO"
  server         = azurerm_sql_server.server
}
