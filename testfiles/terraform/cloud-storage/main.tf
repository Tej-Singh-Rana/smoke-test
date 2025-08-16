provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "bucket" {
  name          = var.bucket_name
  location      = var.region
  storage_class = var.storage_class
  force_destroy = true

  uniform_bucket_level_access = true

  versioning {
    enabled = false
  }

  labels = {
    environment = "dev"
    purpose     = "demo"
  }

  retention_policy {
    is_locked = false
    retention_period = 0
  }
}
