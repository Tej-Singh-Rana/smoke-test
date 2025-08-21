output "load_balancer_ip" {
  value = google_compute_global_forwarding_rule.http_rule.ip_address
}

output "extra_rule1_ip" {
  value = google_compute_global_forwarding_rule.extra_rule1.ip_address
}
output "extra_rule2_ip" {
  value = google_compute_global_forwarding_rule.extra_rule2.ip_address
}
output "extra_rule3_ip" {
  value = google_compute_global_forwarding_rule.extra_rule3.ip_address
}
output "extra_rule4_ip" {
  value = google_compute_global_forwarding_rule.extra_rule4.ip_address
}
output "extra_rule5_ip" {
  value = google_compute_global_forwarding_rule.extra_rule5.ip_address
}
output "extra_rule6_ip" {
  value = google_compute_global_forwarding_rule.extra_rule6.ip_address
}
output "extra_rule7_ip" {
  value = google_compute_global_forwarding_rule.extra_rule7.ip_address
}
