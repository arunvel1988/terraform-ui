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

# Startup script to install Apache
data "template_file" "startup_script" {
  template = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y apache2
              systemctl start apache2
              echo "Hello from Terraform GCP with Load Balancer" > /var/www/html/index.html
            EOF
}

# Firewall allowing SSH (22) and HTTP (80)
resource "google_compute_firewall" "allow_ssh_http" {
  name    = "allow-ssh-http"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Instance template (used for managed instance group)
resource "google_compute_instance" "web" {
  name         = var.instance_name
  machine_type = var.instance_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian.self_link
      size  = 10
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnet

    access_config {}  # External IP
  }

  metadata_startup_script = data.template_file.startup_script.rendered

  tags = ["web"]
}

# Data source for latest Debian image
data "google_compute_image" "debian" {
  family  = "debian-11"
  project = "debian-cloud"
}

# Health check for the backend
resource "google_compute_health_check" "http_health_check" {
  name               = "http-health-check"
  check_interval_sec = 30
  timeout_sec        = 10

  http_health_check {
    port = 80
    request_path = "/"
  }
}

# Backend service
resource "google_compute_backend_service" "web_backend" {
  name                  = "web-backend"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.http_health_check.self_link]
  backend {
    group = google_compute_instance.web.self_link
  }
}

# URL Map
resource "google_compute_url_map" "web_url_map" {
  name            = "web-url-map"
  default_service = google_compute_backend_service.web_backend.self_link
}

# Target HTTP Proxy
resource "google_compute_target_http_proxy" "web_http_proxy" {
  name   = "web-http-proxy"
  url_map = google_compute_url_map.web_url_map.self_link
}

# Global Forwarding Rule
resource "google_compute_global_address" "lb_ip" {
  name = "web-lb-ip"
}

resource "google_compute_global_forwarding_rule" "web_forwarding_rule" {
  name                  = "http-content-rule"
  target                = google_compute_target_http_proxy.web_http_proxy.self_link
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.lb_ip.address
}
