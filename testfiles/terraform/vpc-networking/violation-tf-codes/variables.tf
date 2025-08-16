variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "Region to deploy resources"
  type        = string
  default     = "us-central1"
}

variable "vpc_name" {
  description = "Custom VPC name"
  type        = string
  default     = "vpn-test-vpc"
}
