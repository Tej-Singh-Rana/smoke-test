provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_dns_managed_zone" "public_zone" {
  name        = var.zone_name
  dns_name    = var.dns_name
  description = "Terraform-managed public DNS zone"
  visibility  = "public"
}

resource "google_dns_record_set" "a_record" {
  name         = "www.${var.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.public_zone.name

  rrdatas = ["203.0.113.42"]  # Replace with your IP
}
