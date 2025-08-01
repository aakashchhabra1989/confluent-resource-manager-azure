# Resource Protection Management

This project includes configurable `prevent_destroy` lifecycle blocks on all important resources to prevent accidental deletion. All resources currently have `prevent_destroy = false` by default.

## Current Resources with Lifecycle Protection

### Main Infrastructure
- **Confluent Environment** (`main.tf`)
- **Azure Kafka Cluster** (`AZURE/azure_cluster.tf`)
- **Service Accounts** (`AZURE/azure_cluster.tf`)
- **API Keys** (`AZURE/azure_cluster.tf`)
- **Flink Compute Pool** (`AZURE/azure_flink.tf`)

### Sample Project Resources
- **Kafka Topics** (`AZURE/sample_project/topics.tf`)
- **HTTP Source Connector** (`AZURE/sample_project/http_source_connector.tf`)

## Managing Prevent Destroy Settings

### Option 1: Using PowerShell Script (Windows)
```powershell
# Enable protection (prevent destroy)
.\toggle-prevent-destroy.ps1 true

# Disable protection (allow destroy)
.\toggle-prevent-destroy.ps1 false
```

### Option 2: Using Bash Script (Linux/Mac)
```bash
# Enable protection (prevent destroy)
./toggle-prevent-destroy.sh true

# Disable protection (allow destroy)
./toggle-prevent-destroy.sh false
```

### Option 3: Manual Configuration
You can manually edit the lifecycle blocks in the Terraform files:

```terraform
lifecycle {
  prevent_destroy = true   # Enable protection
  # OR
  prevent_destroy = false  # Disable protection (allow destroy)
}
```

## Important Notes

1. **Production Environments**: Consider setting `prevent_destroy = true` for production resources
2. **Development/Testing**: Keep `prevent_destroy = false` for easier cleanup
3. **Terraform Limitations**: Variables cannot be used in lifecycle blocks, so values must be hardcoded
4. **Always Review**: Run `terraform plan` after changes to review the impact

## Recommended Usage

- **For Production**: Set `prevent_destroy = true` before deployment
- **For Development**: Keep `prevent_destroy = false` for easy cleanup
- **For Experimentation**: Use `prevent_destroy = false` to allow easy resource destruction

## Example Workflow

1. **Development Phase**:
   ```powershell
   .\toggle-prevent-destroy.ps1 false
   terraform apply
   # ... develop and test ...
   terraform destroy  # Easy cleanup
   ```

2. **Production Deployment**:
   ```powershell
   .\toggle-prevent-destroy.ps1 true
   terraform apply
   # Resources are now protected from accidental deletion
   ```
