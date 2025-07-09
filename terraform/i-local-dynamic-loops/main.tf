provider "docker" {}

# ✅ Local value to generate full container names
locals {
  full_names = [for name in var.container_names : "nginx-${name}"]
}

resource "docker_image" "nginx" {
  name = var.image_name
}

resource "docker_container" "nginx" {
  count = var.enable_containers ? length(local.full_names) : 0

  name  = local.full_names[count.index]
  image = docker_image.nginx.name

  # ✅ Dynamic port block
  dynamic "ports" {
    for_each = [
      var.port_map[var.container_names[count.index]]
    ]
    content {
      internal = ports.value.internal
      external = ports.value.external
    }
  }

  # Just for demo - set an env var showing index
  env = [
    "CONTAINER_INDEX=${count.index}"
  ]
}
