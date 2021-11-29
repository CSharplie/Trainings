$ErrorActionPreference = "Stop"

terraform init -backend-config="configuration/backend.dev.conf"
terraform fmt -recursive
terraform fmt -check -recursive
terraform plan