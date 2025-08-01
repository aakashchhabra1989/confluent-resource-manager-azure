# Multi-Environment Azure Confluent Cloud Setup

This Terraform configuration supports managing multiple environments with a modular architecture. The project uses a dedicated `azure_sample_project` module to demonstrate multi-environment patterns that can be replicated for additional projects.

## 🏗️ Architecture Overview

### Module Structure
```
AZURE/
├── azure_cluster.tf                    # Shared cluster infrastructure
├── azure_sample_project_integration.tf # Module integration
└── sample_project/                     # Project-specific module
    ├── main.tf                         # Module configuration
    ├── variables.tf                    # Input variables
    ├── outputs.tf                      # Module outputs  
    ├── versions.tf                     # Provider requirements
    ├── topics.tf                       # Kafka topics
    ├── schemas.tf                      # Schema definitions
    ├── http_source_connector.tf        # HTTP connectors
    ├── flink_*.tf                      # Flink resources
    └── schemas/                      # Environment-specific schemas
        ├── DEV/
        ├── QA/
        ├── UAT/
        └── PROD/
```

## 🌍 Environment Structure

### Non-Production Environment (`non-prod-env`)
- **Sub-environments**: dev, qa, uat
- **Topics**: 
  - `aws.myorg.dev.sample_project.*`
  - `aws.myorg.qa.sample_project.*`
  - `aws.myorg.uat.sample_project.*`
- **Schemas**: Environment-specific schemas from `DEV/`, `QA/`, `UAT/` folders
- **Connectors**: One HTTP source connector per sub-environment
- **Resource Count**: 9 topics, 6 schemas, 3 connectors, 6 ACLs

### Production Environment (`prod-env`)
- **Sub-environments**: prod
- **Topics**: `aws.myorg.prod.sample_project.*`
- **Schemas**: Production schemas from `PROD/` folder
- **Connectors**: One HTTP source connector for production
- **Resource Count**: 3 topics, 2 schemas, 1 connector, 2 ACLs

## 🚀 Deployment Commands

### Deploy Non-Production (dev, qa, uat)
```powershell
# Plan deployment
terraform plan -var-file="non-prod.tfvars"

# Apply changes
terraform apply -var-file="non-prod.tfvars" -auto-approve
```

### Deploy Production (prod only)
```powershell
# Plan deployment
terraform plan -var-file="prod.tfvars"

# Apply changes
terraform apply -var-file="prod.tfvars" -auto-approve
```

### Environment Switching
```powershell
# Switch from prod to non-prod (destroys prod, creates dev/qa/uat)
terraform apply -var-file="non-prod.tfvars"

# Switch from non-prod to prod (destroys dev/qa/uat, creates prod)
terraform apply -var-file="prod.tfvars"
```

### Validation Commands
```powershell
# Initialize and validate
terraform init
terraform validate

# Check for configuration drift
terraform plan -var-file="non-prod.tfvars"
terraform plan -var-file="prod.tfvars"
```

## 🏷️ Resource Naming Convention

All resources follow the pattern: `aws.myorg.{environment}.{project_name}.{resource_name}`

| Resource Type | Non-Prod Pattern | Production Pattern |
|---------------|------------------|-------------------|
| **Topics** | `aws.myorg.{dev\|qa\|uat}.sample_project.{topic_name}` | `aws.myorg.prod.sample_project.{topic_name}` |
| **Schemas** | `aws.myorg.{dev\|qa\|uat}.sample_project.{schema_name}` | `aws.myorg.prod.sample_project.{schema_name}` |
| **Connectors** | `HttpSourceConnector_aws-non-prod-cluster_{dev\|qa\|uat}_sample_project` | `HttpSourceConnector_aws-prod-cluster_prod_sample_project` |

### Actual Resource Examples

#### Topics Created:
- `aws.myorg.dev.sample_project.dummy_topic.0`
- `aws.myorg.qa.sample_project.dummy_topic_with_schema`  
- `aws.myorg.uat.sample_project.http_source_data.source-connector`
- `aws.myorg.prod.sample_project.dummy_topic.0`

#### Schemas Created:
- `aws.myorg.dev.sample_project.dummy_topic_with_schema-key`
- `aws.myorg.qa.sample_project.dummy_topic_with_schema-value`
- `aws.myorg.prod.sample_project.dummy_topic_with_schema-key`

#### Connectors Created:
- `HttpSourceConnector_aws-non-prod-cluster_dev_sample_project`
- `HttpSourceConnector_aws-prod-cluster_prod_sample_project`

## 📁 Schema File Organization

```
AWS/sample_project/schemas/
├── DEV/                    # Development schemas
│   └── user_id_key.avsc   # Dev-specific schema content
├── QA/                     # QA testing schemas  
│   └── user_id_key.avsc   # QA-specific schema content (with qa_testing_flag)
├── UAT/                    # User acceptance testing schemas
│   └── user_id_key.avsc   # UAT-specific schema content (with uat_approval_status)
└── PROD/                   # Production schemas
    └── user_id_key.avsc   # Production schema content (with profile_status)
```

### Schema Variations by Environment
- **DEV**: Basic schema structure for development
- **QA**: Includes `qa_testing_flag` boolean field
- **UAT**: Includes `uat_approval_status` string field  
- **PROD**: Includes `profile_status` string field

## ✨ Key Features

1. **Environment Isolation**: Complete separation between non-prod and prod environments
2. **Sub-Environment Support**: Multiple environments within non-prod (dev, qa, uat)
3. **Modular Architecture**: Project-specific modules for easy replication and scaling
4. **Dynamic Resource Creation**: Resources created per sub-environment using `for_each`
5. **Schema Versioning**: Environment-specific schema files with different field configurations
6. **Connector Isolation**: Separate HTTP source connectors per sub-environment
7. **Consistent Naming**: Standardized naming convention across all resources
8. **Project Hardcoding**: Project name (`sample_project`) is hardcoded within the module
9. **Easy Scaling**: Simple to add new projects by creating additional modules

## 🔧 Configuration Variables

### Root Variables (main.tf)
- `environment_id`: Confluent environment ID
- `environment_resource_name`: Environment resource name
- `environment_type`: Environment type (non-prod, prod, sandbox)
- `sub_environments`: List of sub-environments to create
- `topic_base_prefix`: Base prefix for topic naming (`aws.myorg`)

### Module Variables (sample_project/variables.tf)
- AWS cluster configuration (cluster ID, endpoints, API keys)
- Service account references (admin, app manager)
- Schema Registry configuration
- Flink compute pool reference
- Environment-specific variables passed from parent

## 📊 Deployment Status

### Current Resource Inventory

| Environment | Status | Topics | Schemas | Connectors | ACLs |
|-------------|---------|--------|---------|------------|------|
| **dev**     | ✅ Active | 3 | 2 | 1 | 2 |
| **qa**      | ✅ Active | 3 | 2 | 1 | 2 |
| **uat**     | ✅ Active | 3 | 2 | 1 | 2 |
| **prod**    | ✅ Active | 3 | 2 | 1 | 2 |
| **Total**   | **✅ Deployed** | **12** | **8** | **4** | **8** |

### Resource Types by Environment

#### Non-Production Deployment (when using non-prod.tfvars):
- **Topics**: 
  - `aws.myorg.dev.sample_project.dummy_topic.0`
  - `aws.myorg.dev.sample_project.dummy_topic_with_schema`
  - `aws.myorg.dev.sample_project.http_source_data.source-connector`
  - (Similar for qa, uat)
- **Schemas**: Uses schemas from `DEV/`, `QA/`, `UAT/` folders
- **Connectors**: 3 connectors (dev, qa, uat)

#### Production Deployment (when using prod.tfvars):
- **Topics**: 
  - `aws.myorg.prod.sample_project.dummy_topic.0`
  - `aws.myorg.prod.sample_project.dummy_topic_with_schema`
  - `aws.myorg.prod.sample_project.http_source_data.source-connector`
- **Schemas**: Uses schemas from `PROD/` folder
- **Connectors**: 1 connector (prod)

## 🔄 Scaling Patterns

### Adding New Projects
1. Create new module: `AWS/new_project/`
2. Copy structure from `sample_project/`
3. Update `locals.project_name` to `"new_project"`
4. Create integration file: `AWS/new_project_integration.tf`
5. Deploy with same tfvars files

### Adding New Environments
1. Add environment to `sub_environments` in tfvars
2. Create schema folder: `schemas/NEW_ENV/`
3. Resources automatically created via `for_each`

This setup provides complete environment isolation while maintaining a single, manageable Terraform codebase that can scale to multiple projects and environments.
