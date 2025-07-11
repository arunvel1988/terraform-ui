terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # This backend stores Terraform state locally (for learning/dev)
  backend "local" {}
}

# Azure authentication options:
# You can authenticate via environment variables, CLI login, or managed identity.

# Option 1: Use Azure CLI (preferred for dev/test)
# Run `az login` before using Terraform

# Option 2: Set environment variables:
# export ARM_CLIENT_ID=your-client-id
# export ARM_CLIENT_SECRET=your-client-secret
# export ARM_SUBSCRIPTION_ID=your-subscription-id
# export ARM_TENANT_ID=your-tenant-id

# Azure provider setup
provider "azurerm" {
  features {}

  # optional: explicitly set subscription_id or tenant_id
  # subscription_id = var.subscription_id
  # tenant_id       = var.tenant_id
}
