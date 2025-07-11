output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "storage_account_primary_web_endpoint" {
  value = azurerm_storage_account.storage.primary_web_endpoint
}

output "container_name" {
  value = azurerm_storage_container.container.name
}

output "container_url" {
  value = "https://${azurerm_storage_account.storage.name}.blob.core.windows.net/${azurerm_storage_container.container.name}"
}
