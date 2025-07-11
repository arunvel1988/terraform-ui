output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

output "storage_account_name" {
  value = azurerm_storage_account.example.name
}

output "storage_account_blob_endpoint" {
  value = azurerm_storage_account.example.primary_blob_endpoint
}

output "container_url" {
  value = "https://${azurerm_storage_account.example.name}.blob.core.windows.net/${azurerm_storage_container.example.name}"
}
