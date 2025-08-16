output "vpc_name" {
  value = google_compute_network.vpc_network.name
}

output "subnet_name" {
  value = google_compute_subnetwork.subnet.name
}

output "cloud_nat_name" {
  value = google_compute_router_nat.cloud_nat.name
}
