# Azure Confluent Cloud - Quick Reference

## 🚀 Quick Deployment Commands

### Sandbox Environment
```bash
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

### Non-Production (Dev/QA/UAT)
```bash
terraform plan -var-file="non-prod.tfvars"
terraform apply -var-file="non-prod.tfvars"
```

### Production
```bash
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

## 📋 Environment Overview

| Environment | Config File | Sub-Environments | Cluster Name | Flink Status | Resources |
|-------------|-------------|------------------|--------------|--------------|-----------|
| Sandbox | terraform.tfvars | sandbox | azure-sandbox-cluster | ✅ Enabled | 3 topics, 1 connector |
| Non-Prod | non-prod.tfvars | dev, qa, uat | azure-non-prod-cluster | ✅ Enabled | 9 topics, 3 connectors |
| Production | prod.tfvars | prod | azure-prod-cluster | ❌ Disabled | 3 topics, 1 connector |

## 🏷️ Resource Naming Pattern

```
azure.myorg.{environment}.sample_project.{resource_name}
```

**Examples:**
- `azure.myorg.sandbox.sample_project.dummy_topic.0`
- `azure.myorg.dev.sample_project.dummy_topic_with_schema`
- `azure.myorg.prod.sample_project.http_source_data.source-connector`

## 🔗 HTTP Connector Pattern

```
HttpSourceConnector_azure-{cluster-type}-cluster_{environment}_sample_project
```

**Examples:**
- `HttpSourceConnector_azure-sandbox-cluster_sandbox_sample_project`
- `HttpSourceConnector_azure-non-prod-cluster_dev_sample_project`
- `HttpSourceConnector_azure-prod-cluster_prod_sample_project`

## 🗂️ Module Structure

```
Root Module
├── Configuration (terraform.tfvars, *.tfvars)
├── AZURE Module
│   ├── azure_cluster.tf (Kafka clusters)
│   ├── azure_flink.tf (Flink compute pools)
│   └── azure_sample_project_integration.tf
└── Sample Project Module
    ├── topics.tf (Topic definitions)
    ├── http_source_connector.tf (Connectors)
    └── flink_*.tf (Flink statements - commented)
```

## ⚙️ Key Configuration Variables

### Core Settings
```hcl
confluent_cloud_api_key = "your-api-key"
confluent_cloud_api_secret = "your-api-secret"
environment_name = "sandbox-env" # or "non-prod-env", "prod-env"
environment_type = "sandbox"     # or "non-prod", "prod"
sub_environments = ["sandbox"]   # or ["dev","qa","uat"], ["prod"]
```

### Azure Settings
```hcl
azure_topic_base_prefix = "azure.myorg"
azure_cluster_region = "eastus"
azure_cluster_availability = "SINGLE_ZONE"
azure_cluster_cloud = "AZURE"
```

### Flink Settings
```hcl
flink_max_cfu = 5
enable_flink = true  # false for production
```

## 🛡️ Lifecycle Protection

Toggle resource protection:
```bash
# PowerShell
.\toggle-prevent-destroy.ps1

# Bash
./toggle-prevent-destroy.sh
```

## 🎯 Validation Commands

```bash
terraform init
terraform validate
terraform plan -var-file="<environment>.tfvars"
```

## 🧹 Cleanup Commands

```bash
# Destroy specific environment
terraform destroy -var-file="<environment>.tfvars"

# Validate state
terraform show
terraform state list
```

## 📊 Resource Count Summary

- **Total Clusters**: 3 (sandbox, non-prod, prod)
- **Total Environments**: 3 (sandbox-env, non-prod-env, prod-env)
- **Total Topics**: 15 (3 per environment × 5 environments)
- **Total Connectors**: 5 (1 per environment)
- **Flink Pools**: 1 (shared across environments)

## 🚨 Current Limitations

- **Schema Registry**: Disabled due to environment constraints
- **Flink Statements**: Commented out due to authorization issues
- **ACL Management**: Not currently implemented

---

*Quick Reference for Azure Confluent Cloud Terraform Setup*
