# Confluent Cloud Multi-Environment Management

This project supports multiple environments (non-prod and prod) using the same Terraform configuration.

## Environment Deployment

### Deploy Non-Production Environment
```powershell
terraform apply -var-file="non-prod.tfvars" -auto-approve
```

### Deploy Production Environment
```powershell
terraform apply -var-file="prod.tfvars" -auto-approve
```

### Plan Changes for Specific Environment
```powershell
# Non-prod
terraform plan -var-file="non-prod.tfvars"

# Production
terraform plan -var-file="prod.tfvars"
```

### Destroy Environment
```powershell
# Non-prod
terraform destroy -var-file="non-prod.tfvars" -auto-approve

# Production
terraform destroy -var-file="prod.tfvars" -auto-approve
```

## Environment Differences

| Component | Non-Prod | Production |
|-----------|----------|------------|
| Environment Name | `non-prod-env` | `prod-env` |
| Cluster Name | `aws-non-prod-cluster` | `aws-prod-cluster` |
| Topic Prefix | `aws.sampleproject.dev` | `aws.sampleproject.prod` |
| Schema Folder | `Dev/` | `Prod/` |
| Flink CFU | 5 | 10 |
| Topic Partitions | 3 | 6 |

## Schema Management

- **Dev Schemas**: Located in `AWS/schemas/Dev/`
- **Prod Schemas**: Located in `AWS/schemas/Prod/`

Each environment automatically uses its respective schema folder based on the `schema_environment_folder` variable.

## Best Practices

1. Always test changes in non-prod first
2. Use `terraform plan` before `terraform apply`
3. Keep schema files synchronized between environments
4. Monitor resource quotas when scaling up production
