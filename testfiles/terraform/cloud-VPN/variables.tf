variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for VPN setup"
  type        = string
  default     = "us-central1"
}
