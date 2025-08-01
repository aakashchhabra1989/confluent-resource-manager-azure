# Azure Terraform Destruction Guide

## Current Protected Resources:
- Environment: confluent_environment.main
- Kafka Cluster: module.azure_cluster.confluent_kafka_cluster.azure_basic
- Service Accounts: azure_admin_manager, azure_app_manager
- API Keys: azure_admin_manager_kafka_api_key
- ACLs: All azure_app_manager ACLs
- Topics: azure_topics, azure_sample_project topics

## Destruction Options:

### Option 1: Complete Destruction (Recommended)
```powershell
# Step 1: Remove lifecycle protection (modify files)
# Step 2: Plan destruction
terraform plan -destroy -var-file="azure.tfvars"

# Step 3: Execute destruction
terraform destroy -var-file="azure.tfvars"

# Step 4: Clean up state files
Remove-Item terraform.tfstate*
```

### Option 2: Selective Destruction
```powershell
# Destroy only specific resources
terraform destroy -var-file="azure.tfvars" -target=module.azure_cluster.confluent_kafka_topic.azure_topics[\"sandbox\"]
terraform destroy -var-file="azure.tfvars" -target=module.azure_cluster.confluent_kafka_cluster.azure_basic
terraform destroy -var-file="azure.tfvars" -target=confluent_environment.main
```

### Option 3: Force Destruction (Use with caution)
```powershell
# Remove from state without destroying (if resources already deleted manually)
terraform state rm confluent_environment.main
terraform state rm module.azure_cluster.confluent_kafka_cluster.azure_basic
# ... etc for each resource
```

### Option 4: Manual Cleanup
1. Delete resources manually in Confluent Cloud Console
2. Remove from Terraform state: `terraform state rm <resource_name>`
3. Clean up state files

## Cost Impact:
- Kafka Cluster: Stops billing immediately
- Topics: No separate billing (included with cluster)
- Service Accounts/API Keys: No cost
- Environment: No cost (container only)

## Data Impact:
⚠️ WARNING: All data in topics will be permanently lost!
⚠️ WARNING: All configurations will be permanently deleted!

## Recovery:
- Requires complete re-deployment
- Data cannot be recovered
- API keys will be regenerated (update applications)
