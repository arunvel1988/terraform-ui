output "container_names" {
  value = docker_container.nginx[*].name
}

output "container_ports" {
  value = [
    for c in docker_container.nginx :
    "🔌 ${c.name} exposed on ${c.ports[0].external}"
  ]
}
