output "container_names" {
  value = [for c in docker_container.nginx : c.name]
}


