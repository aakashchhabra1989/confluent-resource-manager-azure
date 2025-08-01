# Azure Confluent Cloud Architecture Summary

## 🏗️ Architecture Overview

This document provides a comprehensive overview of the Azure-based Confluent Cloud Terraform infrastructure, detailing the complete migration from AWS to Azure and the current multi-environment setup.

## 📋 Current Architecture State

### **Platform Configuration**
- **Cloud Provider**: Microsoft Azure (East US Region)
- **Deployment Tool**: Terraform
- **Infrastructure as Code**: Terraform modules with environment-specific configurations
- **Multi-Environment Support**: Sandbox, Development, QA, UAT, and Production

### **Environment Configurations**

| Environment | Configuration File | Sub-Environments | Flink Status | Total Resources |
|-------------|-------------------|------------------|--------------|-----------------|
| Sandbox | `terraform.tfvars` | sandbox | ✅ Enabled | 3 topics, 1 connector |
| Non-Production | `non-prod.tfvars` | dev, qa, uat | ✅ Enabled | 9 topics, 3 connectors |
| Production | `prod.tfvars` | prod | ❌ Disabled | 3 topics, 1 connector |

## 🗂️ Module Structure

```
Root Module (main.tf)
├── Configuration Files
│   ├── terraform.tfvars      # Sandbox environment
│   ├── non-prod.tfvars       # Dev/QA/UAT environments
│   └── prod.tfvars           # Production environment
├── AZURE Module
│   ├── azure_cluster.tf      # Kafka cluster definitions
│   ├── azure_flink.tf        # Flink compute pool configuration
│   ├── azure_sample_project_integration.tf  # Sample project integration
│   ├── outputs.tf            # Module outputs
│   └── variables.tf          # Module variables
└── Sample Project Module
    ├── topics.tf             # Kafka topic definitions
    ├── http_source_connector.tf  # HTTP source connector
    ├── flink_*.tf            # Flink statements (commented out)
    ├── schemas/              # Avro schema files per environment
    └── flink/sql/            # SQL files for Flink processing
```

## 🌍 Azure-Specific Configuration

### **Cluster Configuration**
```hcl
azure_cluster_region = "eastus"
azure_cluster_availability = "SINGLE_ZONE"
azure_cluster_cloud = "AZURE"
azure_topic_base_prefix = "azure.myorg"
```

### **Cluster Names**
- **Sandbox**: `azure-sandbox-cluster`
- **Non-Production**: `azure-non-prod-cluster`
- **Production**: `azure-prod-cluster`

### **Topic Naming Convention**
```
azure.myorg.{environment}.sample_project.{topic_name}
```

**Examples:**
- `azure.myorg.sandbox.sample_project.dummy_topic.0`
- `azure.myorg.dev.sample_project.dummy_topic_with_schema`
- `azure.myorg.prod.sample_project.http_source_data.source-connector`

## 🔗 Resource Dependencies

### **Topic Types per Environment**
1. **dummy_topic.0** - Basic Kafka topic for testing
2. **dummy_topic_with_schema** - Topic with Avro schema support
3. **http_source_data.source-connector** - Topic for HTTP source connector data

### **HTTP Source Connectors**
Each environment has its own HTTP source connector:
- **Naming Pattern**: `HttpSourceConnector_azure-{cluster-type}-cluster_{environment}_sample_project`
- **Data Source**: JSON Placeholder API (https://jsonplaceholder.typicode.com/posts/1)
- **Target Topic**: `http_source_data.source-connector`

### **Flink Integration**
- **Compute Pool**: `azure-flink-compute-pool`
- **Max CFU**: 5
- **Status**: Enabled for all non-production environments, disabled for production
- **SQL Processing**: Available in `AZURE/sample_project/flink/sql/` (commented out due to authorization issues)

## 🚀 Deployment Guide

### **Prerequisites**
1. Confluent Cloud API credentials
2. Terraform >= 1.0
3. Azure CLI (optional, for integration)

### **Environment Deployment**

#### **Deploy Sandbox Environment**
```bash
terraform init
terraform validate
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

#### **Deploy Non-Production (Dev/QA/UAT)**
```bash
terraform plan -var-file="non-prod.tfvars"
terraform apply -var-file="non-prod.tfvars"
```

#### **Deploy Production**
```bash
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

### **Environment Switching**
Switching between environments will destroy existing resources and create new ones:

```bash
# Switch from any environment to another
terraform apply -var-file="<target-environment>.tfvars"
```

## 🛡️ Lifecycle Management

### **Resource Protection**
- **Default State**: `prevent_destroy = false`
- **Toggle Scripts**: Available for enabling/disabling resource protection
  - PowerShell: `toggle-prevent-destroy.ps1`
  - Bash: `toggle-prevent-destroy.sh`

### **State Management**
- **Current State**: `terraform.tfstate`
- **Backup Cleanup**: All backup state files have been removed
- **Recovery**: State import capabilities available for resource recovery

## 🔧 Key Features

### **✅ Implemented Features**
- Complete Azure migration from AWS
- Multi-environment support (5 environments)
- Flink compute pool integration
- HTTP source connectors with external API
- Environment-specific configuration management
- Lifecycle protection scripts
- Clean resource naming conventions

### **⚠️ Known Limitations**
- **Schema Registry**: Disabled due to environment limitations
- **Flink Statements**: Commented out due to authorization constraints
- **ACL Management**: Not currently implemented

### **🔮 Future Enhancements**
- Re-enable Schema Registry when environment supports it
- Implement Flink statements when authorization is resolved
- Add ACL management for production security
- Implement CI/CD pipeline integration
- Add monitoring and alerting

## 📊 Resource Summary

| Component | Sandbox | Dev | QA | UAT | Prod | Total |
|-----------|---------|-----|----|----|------|-------|
| **Topics** | 3 | 3 | 3 | 3 | 3 | **15** |
| **Connectors** | 1 | 1 | 1 | 1 | 1 | **5** |
| **Clusters** | 1 | - | - | - | 1 | **3** |
| **Environments** | 1 | - | - | - | 1 | **3** |

*Note: Dev, QA, and UAT share the same non-prod cluster and environment*

## 🎯 Architecture Benefits

1. **Cloud-Native**: Fully Azure-integrated infrastructure
2. **Scalable**: Multi-environment support with independent scaling
3. **Maintainable**: Clean module structure with clear separation of concerns
4. **Flexible**: Environment-specific configurations and easy switching
5. **Secure**: Lifecycle protection and state management
6. **Observable**: Comprehensive logging and monitoring capabilities
7. **Cost-Effective**: Single-zone deployment with optimized resource allocation

---

*Azure Confluent Cloud Architecture - Terraform Multi-Environment Setup*
*Last Updated: August 1, 2025*
