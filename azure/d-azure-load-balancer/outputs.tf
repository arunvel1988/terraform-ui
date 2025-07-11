output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}

output "load_balancer_frontend_ip" {
  value = azurerm_public_ip.pip.ip_address
}
