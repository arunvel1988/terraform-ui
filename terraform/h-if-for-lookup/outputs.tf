# Output container names using `for` expression
output "container_names" {
  value = [for c in docker_container.nginx : c.name]
}

# Output container ports using `for` and `lookup`
output "container_ports" {
  value = [for i in range(length(var.container_names)) :
    "${var.container_names[i]} → ${lookup(var.port_map, var.container_names[i], 8080)}"
  ]
}

# Output only if `enable_containers` is true — using `if` expression
output "container_summary_if_enabled" {
  value = var.enable_containers ? [for c in docker_container.nginx : "✅ ${c.name} exposed on port ${c.ports[0].external}"] : []
}
