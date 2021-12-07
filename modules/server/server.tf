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
  suffix         = "01"
  server         = azurerm_sql_server.server
}

module "database_02" {
  source         = "../../modules/database"
  resource_group = var.resource_group
  environment    = var.environment
  suffix         = "02"
  server         = azurerm_sql_server.server
}
  
  module "database_03" {
  source         = "../../modules/database"
  resource_group = var.resource_group
  environment    = var.environment
  suffix         = "03"
  server         = azurerm_sql_server.server
}

