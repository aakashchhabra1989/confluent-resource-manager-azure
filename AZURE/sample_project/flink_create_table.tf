# Create User Table - Flink SQL Statement for Azure
# This file references external SQL file for better maintainability
# TEMPORARILY DISABLED: Flink statements cause authorization issues with current API key setup

# Create user table for each sub-environment (if Flink is enabled)
# resource "confluent_flink_statement" "azure_create_user_table" {
#   for_each = var.enable_flink ? toset(var.sub_environments) : toset([])
# 
#   organization {
#     id = "fff9d6dc-e2bb-4bed-bc5a-29ee52937d355"
#   }
# 
#   environment {
#     id = var.environment_id
#   }
#   
#   compute_pool {
#     id = var.flink_compute_pool_id
#   }
# 
#   principal {
#     id = var.admin_service_account_id
#   }
# 
#   # Reference external SQL file with variable substitution
#   statement = templatefile("${path.module}/flink/sql/create_user_table.sql", {
#     project_name         = local.project_name
#     sub_environment      = each.key
#     topic_prefix        = var.topic_prefix
#     cluster_id          = var.cluster_id
#   })
# 
#   properties = {
#     "sql.current-catalog"  = var.environment_id
#     "sql.current-database" = var.cluster_id
#   }
# 
#   rest_endpoint = "https://flink.${var.cluster_region}.azure.confluent.cloud"
# 
#   credentials {
#     key    = var.flink_admin_api_key
#     secret = var.flink_admin_api_secret
#   }
# 
#   lifecycle {
#     prevent_destroy = false
#   }
# }
