terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "local" {}
}

provider "google" {
  project = var.project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}

# Startup script (same as AWS user_data)
data "template_file" "startup_script" {
  template = file("${path.module}/bootstrap.sh")
}

# Firewall to allow SSH
resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]  # 🔒 Restrict this in production
}

# GCP Compute instance
resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian.self_link
      size  = 10
    }
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_name

    access_config {
      # Ephemeral public IP
    }
  }

  metadata_startup_script = data.template_file.startup_script.rendered

  tags = ["ssh"]

  labels = {
    environment = var.environment
  }
}

# Data source for latest Debian image
data "google_compute_image" "debian" {
  family  = "debian-11"
  project = "debian-cloud"
}
