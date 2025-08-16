provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Instance Template
resource "google_compute_instance_template" "web_template" {
  name           = "web-template"
  machine_type   = "e2-micro"
  region         = var.region

  tags = ["http-server"]

  disk {
    auto_delete  = true
    boot         = true
    source_image = "debian-cloud/debian-12"
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl start nginx
  EOF
}

# Managed Instance Group
resource "google_compute_region_instance_group_manager" "web_mig" {
  name               = "web-mig"
  region             = var.region
  version {
    instance_template = google_compute_instance_template.web_template.self_link
  }
  base_instance_name = "web"
  target_size        = 2
}

# Health Check
resource "google_compute_health_check" "hc" {
  name               = "http-health-check"
  check_interval_sec = 5
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 2

  http_health_check {
    port = 80
    request_path = "/"
  }
}

# Backend Service
resource "google_compute_backend_service" "backend" {
  name                  = "web-backend"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.hc.self_link]
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = google_compute_region_instance_group_manager.web_mig.instance_group
  }
}

# URL Map
resource "google_compute_url_map" "url_map" {
  name            = "web-url-map"
  default_service = google_compute_backend_service.backend.self_link
}

# Target HTTP Proxy
resource "google_compute_target_http_proxy" "http_proxy" {
  name   = "web-http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

# Global Forwarding Rule
resource "google_compute_global_forwarding_rule" "http_rule" {
  name       = "http-forwarding-rule"
  ip_protocol = "TCP"
  port_range  = "80"
  target      = google_compute_target_http_proxy.http_proxy.self_link
}
