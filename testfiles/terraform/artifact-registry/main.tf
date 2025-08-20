provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_artifact_registry_repository" "repo" {
  provider     = google
  location     = var.region
  repository_id = var.repo_id
  description  = "Terraform-managed Artifact Registry"
  format       = var.format # e.g., DOCKER
  mode         = "STANDARD"

  docker_config {
    immutable_tags = false
  }
}

# Disable image scanning at project level for Artifact Registry
resource "google_project_service" "artifact_registry_api" {
  service = "artifactregistry.googleapis.com"
}

resource "google_project_settings" "disable_vulnerability_scanning" {
  project = var.project_id

  settings {
    name  = "projects/${var.project_id}/settings"
    policy {
      vulnerability_scanning = "DISABLED"
    }
  }

  depends_on = [google_project_service.artifact_registry_api]
}
