location            = "Australia East"
resource_group_name = "clavillesit72281p-rg"

# Replace with a unique name for your Azure Container Registry 
acr_name = "clavillesit72281pacr"

# Replace with a unique name for your Azure Storage Account
storage_account_name = "clavillesit72281pst"

# Replace with a unique name for your Azure Kubernetes Service cluster
aks_cluster_name = "clavillesit72281p-aks"
aks_dns_prefix   = "clavillesit72281pdns"

aks_node_count   = 3
aks_node_vm_size = "Standard_D2s_v3"

environment = "development"

tags = {
  Project     = "KoalaTech Course Platform"
  ManagedBy   = "Terraform"
  Practical   = "Week08-OT8.1P"
  Environment = "Development"
}