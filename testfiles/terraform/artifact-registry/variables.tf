variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "Region where the repository will be created"
  type        = string
  default     = "us-central1"
}

variable "repo_id" {
  description = "Unique name for the Artifact Registry repository"
  type        = string
  default     = "my-artifact-repo"
}

variable "format" {
  description = "Repository format: DOCKER, MAVEN, NPM, PYTHON, etc."
  type        = string
  default     = "DOCKER"
}
