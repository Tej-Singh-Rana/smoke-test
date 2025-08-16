variable "project_id" {
  description = "Your GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region (not used by DNS but required by provider)"
  type        = string
  default     = "us-central1"
}

variable "zone_name" {
  description = "Unique name of the DNS zone"
  type        = string
  default     = "my-public-zone"
}

variable "dns_name" {
  description = "Domain name (must end with a dot)"
  type        = string
  default     = "example.com."
}
