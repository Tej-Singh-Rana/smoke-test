provider "google" {
  project = var.project_id
}

locals {
  regions = ["us-central1", "us-east1", "us-west1", "us-south1"]  # 4 US regions
}

resource "google_compute_instance" "multi_region_vms" {
  count        = length(local.regions)
  name         = "violation-vm-${count.index + 1}"
  machine_type = "n2-standard-2"  # 2 vCPUs each → total = 8 vCPUs ❌

  zone = "${local.regions[count.index]}-a"  # Use -a zone in each region

  boot_disk {
    initialize_params {
      image = "rhel-cloud/rhel-9"  # ❌ Premium OS image
      size  = 60                   # ❌ Exceeds max disk size (limit = 50GB)
      type  = "pd-balanced"
    }
  }

  network_interface {
    network       = "default"
    access_config {}
  }

  tags = ["violation-test"]
}
