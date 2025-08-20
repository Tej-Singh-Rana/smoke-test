provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "static_site" {
  name     = "${var.project_id}-cdn-bucket"
  location = var.region
  uniform_bucket_level_access = true
  website {
    main_page_suffix = "index.html"
  }
  force_destroy = true
}

resource "google_compute_backend_bucket" "cdn_backend" {
  name        = "cdn-backend"
  bucket_name = google_storage_bucket.static_site.name
  enable_cdn  = true
}

resource "google_compute_url_map" "cdn_url_map" {
  name            = "cdn-url-map"
  default_service = google_compute_backend_bucket.cdn_backend.self_link
}

resource "google_compute_target_http_proxy" "cdn_proxy" {
  name   = "cdn-http-proxy"
  url_map = google_compute_url_map.cdn_url_map.self_link
}

resource "google_compute_global_forwarding_rule" "cdn_forwarding_rule" {
  name                  = "cdn-forwarding-rule"
  target                = google_compute_target_http_proxy.cdn_proxy.self_link
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL"
  ip_protocol           = "TCP"
}
