variable "project_id" {
  description = "Your GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region to deploy router"
  type        = string
  default     = "us-central1"
}
