provider "docker" {}

resource "docker_image" "nginx" {
  name = var.image_name
}

resource "docker_container" "nginx" {
  count   = var.enable_containers ? length(var.container_names) : 0
  name    = "nginx-${var.container_names[count.index]}"
  image   = docker_image.nginx.name
  ports {
    internal = 80
    external = lookup(var.port_map, var.container_names[count.index], 8080)
  }
}
