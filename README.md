# Confluent Resource Manager for Azure

This repository provides Terraform configuration to manage Confluent Cloud resources specifically for Azure deployments. It supports multi-environment setups with dedicated configuration files for sandbox, non-production, and production environments.

## Overview

This project creates and manages:
- Confluent Cloud environments
- Azure-based Kafka clusters
- Topics, schemas, and service accounts
- Access Control Lists (ACLs)
- Apache Flink compute pools and applications
- HTTP source connectors

## Project Structure

```
├── main.tf                 # Main Terraform configuration
├── variables.tf           # Variable definitions
├── outputs.tf            # Output definitions
├── terraform.tfvars      # Sandbox environment configuration
├── non-prod.tfvars       # Non-production environment configuration
├── prod.tfvars           # Production environment configuration
└── AZURE/                # Azure module
    ├── azure_cluster.tf              # Azure Kafka cluster resources
    ├── variables.tf                  # Module variables
    ├── outputs.tf                   # Module outputs
    ├── azure_sample_project_integration.tf  # Sample project integration
    └── sample_project/              # Sample project resources
        ├── main.tf                  # Sample project main config
        ├── variables.tf             # Sample project variables
        ├── topics.tf                # Topic definitions
        ├── schemas.tf               # Schema definitions
        ├── flink_*.tf               # Flink configurations
        ├── http_source_connector.tf # HTTP connector config
        └── flink/sql/               # Flink SQL queries
```

## Environment Configurations

### Sandbox Environment
- **File**: `terraform.tfvars`
- **Environment Name**: `sandbox-env`
- **Sub-environments**: `["sandbox"]`
- **Cluster**: `azure-sandbox-cluster`

### Non-Production Environment
- **File**: `non-prod.tfvars`
- **Environment Name**: `non-prod-env`
- **Sub-environments**: `["dev", "qa", "uat"]`
- **Cluster**: `azure-non-prod-cluster`

### Production Environment
- **File**: `prod.tfvars`
- **Environment Name**: `prod-env`
- **Sub-environments**: `["prod"]`
- **Cluster**: `azure-prod-cluster`

## Prerequisites

1. **Terraform**: Version 1.0 or later
2. **Confluent Cloud Account**: Active account with API access
3. **Azure Subscription**: For deploying Azure-based Kafka clusters

## Setup Instructions

### 1. Configure Confluent Cloud API Credentials

Obtain your API credentials from the Confluent Cloud Console:
1. Navigate to **Cloud API Keys** in the Confluent Cloud Console
2. Create a new API key pair
3. Update the credentials in your chosen `.tfvars` file:

```hcl
confluent_cloud_api_key    = "your-api-key"
confluent_cloud_api_secret = "your-api-secret"
```

### 2. Choose Your Environment

Select the appropriate configuration file based on your target environment:

#### For Sandbox Environment:
```bash
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

#### For Non-Production Environment:
```bash
terraform init
terraform plan -var-file="non-prod.tfvars"
terraform apply -var-file="non-prod.tfvars"
```

#### For Production Environment:
```bash
terraform init
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

## Configuration Variables

### Core Variables
- `confluent_cloud_api_key`: Your Confluent Cloud API key
- `confluent_cloud_api_secret`: Your Confluent Cloud API secret
- `environment_name`: Name of the Confluent environment
- `environment_type`: Type of environment (sandbox/non-prod/prod)
- `sub_environments`: List of sub-environments for topic organization
- `project_name`: Name of the project (default: "sample_project")

### Azure-Specific Variables
- `azure_topic_base_prefix`: Base prefix for topic naming (e.g., "azure.myorg")
- `azure_cluster_name`: Name of the Azure Kafka cluster
- `azure_cluster_region`: Azure region for the cluster (e.g., "eastus")
- `azure_cluster_availability`: Availability configuration (SINGLE_ZONE/MULTI_ZONE)
- `azure_cluster_cloud`: Cloud provider (AZURE)

### Optional Features
- `enable_flink`: Enable Apache Flink compute pools (default: false)
- `flink_max_cfu`: Maximum Confluent Flink Units for Flink pools
- `create_azure_dummy_topic`: Create sample topics for testing

## Sample Project Integration

The `AZURE/sample_project/` directory contains a complete example that demonstrates:
- Topic creation with proper naming conventions
- Schema registry setup with Avro schemas
- Service account and ACL configuration
- Flink compute pools and applications
- HTTP source connector setup

## Topics and Schemas

Topics are automatically created for each sub-environment with the naming pattern:
```
{azure_topic_base_prefix}.{sub_environment}.{topic_name}
```

Example: `azure.myorg.dev.user_profile`

Schemas are organized by environment in the `AZURE/sample_project/schemas/` directory:
- `DEV/`: Development schemas
- `QA/`: QA schemas
- `UAT/`: UAT schemas
- `SANDBOX/`: Sandbox schemas
- `PROD/`: Production schemas

## Outputs

The configuration provides outputs for:
- Environment details (ID, name, resource name)
- Cluster information (ID, name, bootstrap endpoint)
- Service account credentials
- Topic details
- Schema registry information

## Clean Up

To destroy the infrastructure:

```bash
# For sandbox
terraform destroy -var-file="terraform.tfvars"

# For non-prod
terraform destroy -var-file="non-prod.tfvars"

# For production
terraform destroy -var-file="prod.tfvars"
```

## Best Practices

1. **Environment Separation**: Use dedicated `.tfvars` files for each environment
2. **State Management**: Use remote state storage for production environments
3. **Security**: Store API credentials securely (consider using environment variables)
4. **Naming Conventions**: Follow consistent naming patterns for resources
5. **Version Control**: Tag releases and maintain proper versioning

## Troubleshooting

### Common Issues

1. **API Authentication Errors**: Verify your API key and secret are correct
2. **Region Availability**: Ensure Azure region supports Confluent Cloud
3. **Resource Limits**: Check your Confluent Cloud limits for clusters and topics
4. **State Conflicts**: Use `terraform refresh` to sync state with actual resources

### Validation

After deployment, validate your setup:
```bash
terraform validate
terraform plan -var-file="your-environment.tfvars"
```

## Support

For issues and questions:
1. Check Terraform logs for detailed error messages
2. Refer to Confluent Cloud documentation
3. Review Azure region compatibility
4. Verify API key permissions and limits
