provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
  }
}

locals {
  instance_configs = [
    { name = "pg-instance-enterprise-1", tier = "db-custom-2-7680" },
    { name = "pg-instance-enterprise-2", tier = "db-custom-2-7680" },
    { name = "pg-instance-enterprise-3", tier = "db-custom-2-7680" },
  ]
}

resource "google_sql_database_instance" "postgres_instances" {
  for_each         = { for cfg in local.instance_configs : cfg.name => cfg }
  name             = each.value.name
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier              = each.value.tier  # Enterprise-compliant tier
    availability_type = "ZONAL"
    disk_size         = 15
    edition = "ENTERPRISE"
    ip_configuration {
      ipv4_enabled = true
    }

    backup_configuration {
      enabled = true
    }
  }
}

resource "google_sql_user" "users" {
  for_each = google_sql_database_instance.postgres_instances
  name     = var.db_user
  instance = each.value.name
  password = var.db_password
}

resource "google_sql_database" "default_db" {
  for_each = google_sql_database_instance.postgres_instances
  name     = var.db_name
  instance = each.value.name
}
