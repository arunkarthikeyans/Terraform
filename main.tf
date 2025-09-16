terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.94"
    }
  }
}

provider "snowflake" {
  account       = "hmfdpwa-fc41214"
  user          = "TERRAFORM_SVC"
  role          = "SYSADMIN"
  authenticator = "JWT"
  private_key   = file("C:/AK- Learnings/Terraform/snowflake-terraform/snowflake_tf_key.p8")
}

# Create a Database
resource "snowflake_database" "demo_db" {
  name    = "TF_DEMO_DATABASE"
  comment = "Demo database created via Terraform"
}

# Create a Warehouse
resource "snowflake_warehouse" "demo_warehouse" {
  name                = "TF_DEMO_WAREHOUSE"
  warehouse_size      = "XSMALL"
  auto_suspend        = 60
  auto_resume         = true
  initially_suspended = true
  comment             = "Demo warehouse created via Terraform"
}

# Create a Schema
resource "snowflake_schema" "demo_schema" {
  database = snowflake_database.demo_db.name
  name     = "TF_DEMO_SCHEMA"
  comment  = "Demo schema created via Terraform"
}

# Create a Table
resource "snowflake_table" "demo_table" {
  database = snowflake_database.demo_db.name
  schema   = snowflake_schema.demo_schema.name
  name     = "DEMO_TABLE"
  comment  = "Demo table created via Terraform"

  column {
    name     = "ID"
    type     = "NUMBER(10,0)"
    nullable = false
  }

  column {
    name     = "NAME"
    type     = "VARCHAR(100)"
    nullable = true
  }

  column {
    name = "CREATED_DATE"
    type = "TIMESTAMP_NTZ"
    default {
      constant = "CURRENT_TIMESTAMP()"
    }
  }
}

# Outputs
output "database_name" {
  description = "Name of the created database"
  value       = snowflake_database.demo_db.name
}

output "warehouse_name" {
  description = "Name of the created warehouse"
  value       = snowflake_warehouse.demo_warehouse.name
}

output "schema_name" {
  description = "Name of the created schema"
  value       = snowflake_schema.demo_schema.name
}

output "table_name" {
  description = "Name of the created table"
  value       = snowflake_table.demo_table.name
}

output "connection_info" {
  description = "Information for connecting to the created objects"
  value = {
    database  = snowflake_database.demo_db.name
    warehouse = snowflake_warehouse.demo_warehouse.name
    schema    = snowflake_schema.demo_schema.name
    table     = snowflake_table.demo_table.name
  }
}