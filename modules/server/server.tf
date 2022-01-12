variable "resource_group" {}
variable "environment" {}
variable "password" {}

resource "azurerm_sql_server" "server" {
  name                         = "training-cicd-analytics-${var.environment}"
  resource_group_name          = var.resource_group.name
  location                     = var.resource_group.location
  version                      = "12.0"
  administrator_login          = "azuredevops_${var.environment}"
  administrator_login_password = var.password
}

module "database_01" {
  source         = "../../modules/database"
  resource_group = var.resource_group
  environment    = var.environment
  suffix         = "CCO"
  server         = azurerm_sql_server.server
}

module "database_02" {
  source         = "../../modules/database"
  resource_group = var.resource_group
  environment    = var.environment
  suffix         = "LBO"
  server         = azurerm_sql_server.server
}

module "database_03" {
  source         = "../../modules/database"
  resource_group = var.resource_group
  environment    = var.environment
  suffix         = "ARO"
  server         = azurerm_sql_server.server
}

module "database_04" {
  source         = "../../modules/database"
  resource_group = var.resource_group
  environment    = var.environment
  suffix         = "EAU"
  server         = azurerm_sql_server.server
}

module "database_05" {
  source         = "../../modules/database"
  resource_group = var.resource_group
  environment    = var.environment
  suffix         = "HAM"
  server         = azurerm_sql_server.server
}

module "database_06" {
  source         = "../../modules/database"
  resource_group = var.resource_group
  environment    = var.environment
  suffix         = "PBH"
  server         = azurerm_sql_server.server
}

module "database_07" {
  source         = "../../modules/database"
  resource_group = var.resource_group
  environment    = var.environment
  suffix         = "JPA"
  server         = azurerm_sql_server.server
}

module "database_08" {
  source         = "../../modules/database"
  resource_group = var.resource_group
  environment    = var.environment
  suffix         = "WGA"
  server         = azurerm_sql_server.server
}

module "database_07" {
  source         = "../../modules/database"
  resource_group = var.resource_group
  environment    = var.environment
  suffix         = "RGL"
  server         = azurerm_sql_server.server
}

module "database_07" {
  source         = "../../modules/database"
  resource_group = var.resource_group
  environment    = var.environment
  suffix         = "XAL"
  server         = azurerm_sql_server.server
}
