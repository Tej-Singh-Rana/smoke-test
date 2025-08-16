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

# External IP for tunnel
resource "google_compute_address" "vpn_ip" {
  name   = "vpn-ip"
  region = var.region
}

# VPN Tunnel (simulate with dummy peer)
resource "google_compute_vpn_tunnel" "vpn_tunnel" {
  name               = "vpn-tunnel"
  region             = var.region
  target_vpn_gateway = google_compute_vpn_gateway.vpn_gateway.id
  peer_ip            = "203.0.113.1"  # 🔸 Dummy IP for testing
  shared_secret      = "test-secret"
  ike_version        = 2

  local_traffic_selector  = ["0.0.0.0/0"]
  remote_traffic_selector = ["0.0.0.0/0"]

  depends_on = [google_compute_address.vpn_ip]
}

# Route for tunnel
resource "google_compute_route" "vpn_route" {
  name              = "vpn-route"
  network           = google_compute_network.vpn_vpc.name
  dest_range        = "192.168.10.0/24" # 🔸 Remote CIDR
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.vpn_tunnel.id
  priority          = 1000
}
