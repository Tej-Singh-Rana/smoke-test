output "cdn_ip" {
  value = google_compute_global_forwarding_rule.cdn_forwarding_rule.ip_address
}
