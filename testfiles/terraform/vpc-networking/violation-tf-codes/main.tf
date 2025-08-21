provider "google" {
  project = var.project_id
  region  = var.region
}

# Custom VPC
resource "google_compute_network" "custom_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

# Subnet with flow logs (sampling < 30%)
resource "google_compute_subnetwork" "custom_subnet" {
  name                     = "subnet-1"
  ip_cidr_range            = "10.10.0.0/24"
  region                   = var.region
  network                  = google_compute_network.custom_vpc.id
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.2
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Create 9 External IPs
resource "google_compute_address" "external_ips" {
  count  = 9
  name   = "external-ip-${count.index + 1}"
  region = var.region
}

# VPN Gateway
resource "google_compute_vpn_gateway" "vpn_gateway" {
  name    = "my-vpn-gateway"
  region  = var.region
  network = google_compute_network.custom_vpc.id
}

# Simulated 3 VPN Tunnels with valid dummy IPs (replace with real in production)
resource "google_compute_vpn_tunnel" "vpn_tunnels" {
  count               = 3
  name                = "vpn-tunnel-${count.index + 1}"
  region              = var.region
  target_vpn_gateway  = google_compute_vpn_gateway.vpn_gateway.id
  peer_ip             = "8.8.8.${count.index + 1}"  # Safe to use for testing (Google DNS range)
  shared_secret       = "test-shared-secret"
  ike_version         = 2

  depends_on = [google_compute_address.external_ips]
}

