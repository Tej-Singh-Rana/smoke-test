provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "vpc_network" {
  name                    = "cloud-router-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "router-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_router" "cloud_router" {
  name    = "cloud-router"
  region  = var.region
  network = google_compute_network.vpc_network.name

  bgp {
    asn = 64514  # Private ASN range
  }
}
