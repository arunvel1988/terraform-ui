output "instance_external_ip" {
  value = google_compute_instance.web.network_interface[0].access_config[0].nat_ip
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/YOUR_PRIVATE_KEY username@${google_compute_instance.web.network_interface[0].access_config[0].nat_ip}"
}

output "load_balancer_ip" {
  value = google_compute_global_address.lb_ip.address
}
