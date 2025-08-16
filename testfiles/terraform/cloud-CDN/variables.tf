variable "project_id" {
  description = "Your GCP project ID"
  type        = string
}

variable "region" {
  description = "Region for the bucket"
  type        = string
  default     = "us-central1"
}
