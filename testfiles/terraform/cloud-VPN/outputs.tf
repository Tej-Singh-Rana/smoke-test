output "vpn_gateway" {
  value = google_compute_vpn_gateway.vpn_gateway.name
}

output "vpn_tunnel" {
  value = google_compute_vpn_tunnel.vpn_tunnel.name
}

output "vpn_external_ip" {
  value = google_compute_address.vpn_ip.address
}
