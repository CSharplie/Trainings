variable "resource_group" {}
variable "environment" {}
variable "suffix" {}
variable "server" {}

resource "azurerm_sql_database" "db" {
  name                             = "training-cicd-analytics-mssql-${var.suffix}-${var.environment}"
  resource_group_name              = var.resource_group.name
  location                         = var.resource_group.location
  server_name                      = var.server.name
  requested_service_objective_name = "Basic"
  edition                          = "Basic"
  max_size_bytes                   = 2147483648
}
