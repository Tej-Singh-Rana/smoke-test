output "vpn_tunnels" {
  value = [for t in google_compute_vpn_tunnel.vpn_tunnels : t.name]
}

output "external_ips" {
  value = [for ip in google_compute_address.external_ips : ip.address]
}
