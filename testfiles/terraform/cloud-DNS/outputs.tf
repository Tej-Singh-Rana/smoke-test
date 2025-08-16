output "name_servers" {
  description = "The name servers assigned to this zone"
  value       = google_dns_managed_zone.public_zone.name_servers
}
