variable "project_id" {
  description = "Your GCP project ID"
  type        = string
}

variable "region" {
  description = "Region for the storage bucket"
  type        = string
  default     = "US"
}

variable "bucket_name" {
  description = "Globally unique bucket name"
  type        = string
  default     = "my-unique-bucket-kk-456" # Replace with a truly unique name
}

variable "storage_class" {
  description = "Storage class: STANDARD, NEARLINE, COLDLINE, or ARCHIVE"
  type        = string
  default     = "STANDARD"
}
