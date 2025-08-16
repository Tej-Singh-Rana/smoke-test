variable "project_id" {
  description = "Your GCP project ID"
  type        = string
}

variable "region" {
  description = "Region where NAT and subnet will be created"
  type        = string
  default     = "us-central1"
}
