provider "google" {
  project = var.project_id
  region  = var.region
}

# Custom VPC
resource "google_compute_network" "vpn_vpc" {
  name                    = "vpn-vpc"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "vpn_subnet" {
  name          = "vpn-subnet"
  ip_cidr_range = "10.100.0.0/24"
  region        = var.region
  network       = google_compute_network.vpn_vpc.id
}

# VPN Gateway
resource "google_compute_vpn_gateway" "vpn_gateway" {
  name    = "vpn-gateway"
  network = google_compute_network.vpn_vpc.id
  region  = var.region
}

# External IP for VPN
resource "google_compute_address" "vpn_ip" {
  name   = "vpn-ip"
  region = var.region
}

# Forwarding rule for ESP
resource "google_compute_forwarding_rule" "vpn_esp" {
  name        = "vpn-esp-rule"
  region      = var.region
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpn_ip.address
  target      = google_compute_vpn_gateway.vpn_gateway.id
}

# Forwarding rule for UDP 500 and 4500
resource "google_compute_forwarding_rule" "vpn_udp_500" {
  name        = "vpn-udp-500"
  region      = var.region
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.vpn_ip.address
  target      = google_compute_vpn_gateway.vpn_gateway.id
}

resource "google_compute_forwarding_rule" "vpn_udp_4500" {
  name        = "vpn-udp-4500"
  region      = var.region
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.vpn_ip.address
  target      = google_compute_vpn_gateway.vpn_gateway.id
}

# VPN Tunnel
resource "google_compute_vpn_tunnel" "vpn_tunnel" {
  name               = "vpn-tunnel"
  region             = var.region
  target_vpn_gateway = google_compute_vpn_gateway.vpn_gateway.id
  peer_ip            = "1.2.3.4"
  shared_secret      = "test-secret"
  ike_version        = 2

  local_traffic_selector  = ["0.0.0.0/0"]
  remote_traffic_selector = ["0.0.0.0/0"]

  depends_on = [
  google_compute_forwarding_rule.vpn_esp,
  google_compute_forwarding_rule.vpn_udp_500,
  google_compute_forwarding_rule.vpn_udp_4500
]

}

# Route for tunnel
resource "google_compute_route" "vpn_route" {
  name                   = "vpn-route"
  network                = google_compute_network.vpn_vpc.name
  dest_range             = "192.168.10.0/24"
  next_hop_vpn_tunnel    = google_compute_vpn_tunnel.vpn_tunnel.id
  priority               = 1000
}

