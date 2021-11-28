$ErrorActionPreference = "Stop"

terraform init
terraform fmt -recursive
terraform fmt -check -recursive
terraform plan