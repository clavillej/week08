# SIT722 - Ontrack8.1P - Claville (T2-2026)

# Details of the account running Terraform
data "azuread_client_config" "current" {}

data "azurerm_client_config" "current" {}

# App registration for GitHub Actions
resource "azuread_application" "github_actions" {
  display_name = "clavillesit72281p-sp"
  owners       = [data.azuread_client_config.current.object_id]
}

# Service principal associated with the application
resource "azuread_service_principal" "github_actions" {
  client_id = azuread_application.github_actions.client_id
  owners    = [data.azuread_client_config.current.object_id]
}

# Client secret for GitHub Actions authentication
resource "azuread_application_password" "github_actions" {
  application_id = azuread_application.github_actions.id
  display_name   = "clavillesit72281p-github-secret"
  end_date       = "2026-12-31T23:59:59Z"
}

# Allow GitHub Actions to push and pull container images
resource "azurerm_role_assignment" "github_acr_push" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = azuread_service_principal.github_actions.object_id

  skip_service_principal_aad_check = true
}

# Allow GitHub Actions to retrieve the AKS user credentials
resource "azurerm_role_assignment" "github_aks_access" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azuread_service_principal.github_actions.object_id

  skip_service_principal_aad_check = true
}

# Authentication JSON for the GitHub repository secret
output "azure_credentials" {
  description = "JSON for the GitHub AZURE_CREDENTIALS secret"
  sensitive   = true

  value = jsonencode({
    clientId       = azuread_application.github_actions.client_id
    clientSecret   = azuread_application_password.github_actions.value
    subscriptionId = data.azurerm_client_config.current.subscription_id
    tenantId       = data.azurerm_client_config.current.tenant_id
  })
}