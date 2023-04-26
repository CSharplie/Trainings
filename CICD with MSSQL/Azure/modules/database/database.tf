variable "resource_group" {}
variable "environment" {}
variable "suffix" {}
variable "server" {}
variable "spn_id" {}

resource "azurerm_sql_database" "db" {
  name                             = "training-cicd-analytics-${var.suffix}-${var.environment}"
  resource_group_name              = var.resource_group.name
  location                         = var.resource_group.location
  server_name                      = var.server.name
  requested_service_objective_name = "Basic"
  edition                          = "Basic"
  max_size_bytes                   = 2147483648
}

resource "mssql_user" "role_spn" {
  server {
    host = var.server.name
    azure_login {
    }
  }

  database  = azurerm_sql_database.db.name
  username  = "AzureDevOps"
  object_id = var.client_id
  roles     = ["db_owner"]
}