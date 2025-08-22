variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "Region for Cloud SQL"
}

variable "db_user" {
  type        = string
  default     = "postgres"
  description = "Database user"
}

variable "db_password" {
  type        = string
  description = "Password for the database user"
  sensitive   = true
}

variable "db_name" {
  type        = string
  default     = "appdb"
  description = "Initial database name"
}
