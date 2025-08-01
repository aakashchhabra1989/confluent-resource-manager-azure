# Azure Flink Compute Pool Configuration
# This file contains Azure-specific Flink compute pool and related resources

# Create Flink Compute Pool for Azure environment
resource "confluent_flink_compute_pool" "azure_flink_pool" {
  count = var.enable_flink ? 1 : 0

  display_name = "${var.azure_cluster_name}-flink-compute-pool"
  cloud        = var.azure_cluster_cloud
  region       = var.azure_cluster_region
  max_cfu      = var.flink_max_cfu

  environment {
    id = var.environment_id
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Create Flink API Key for admin service account (commenting out due to API limitations)
# resource "confluent_api_key" "azure_admin_flink_api_key" {
#   count = var.enable_flink ? 1 : 0
# 
#   display_name = "${var.azure_cluster_name}-admin-flink-api-key"
#   description  = "Flink API Key for Azure cluster admin"
#   owner {
#     id          = confluent_service_account.azure_admin_manager.id
#     api_version = confluent_service_account.azure_admin_manager.api_version
#     kind        = confluent_service_account.azure_admin_manager.kind
#   }
# 
#   managed_resource {
#     id          = confluent_flink_compute_pool.azure_flink_pool[0].id
#     api_version = "fcpm/v2"
#     kind        = "ComputePool"
# 
#     environment {
#       id = var.environment_id
#     }
#   }
# 
#   lifecycle {
#     prevent_destroy = false
#   }
# }

# Grant Flink Developer permissions to admin service account
resource "confluent_role_binding" "azure_admin_flink_developer" {
  count = var.enable_flink ? 1 : 0

  principal   = "User:${confluent_service_account.azure_admin_manager.id}"
  role_name   = "FlinkDeveloper"
  crn_pattern = var.environment_resource_name
}

# Grant Flink Developer permissions to app manager service account
resource "confluent_role_binding" "azure_app_manager_flink_developer" {
  count = var.enable_flink ? 1 : 0

  principal   = "User:${confluent_service_account.azure_app_manager.id}"
  role_name   = "FlinkDeveloper"
  crn_pattern = var.environment_resource_name
}

# Create Flink API Key for app manager service account (commenting out due to API limitations)
# resource "confluent_api_key" "azure_app_manager_flink_api_key" {
#   count = var.enable_flink ? 1 : 0
# 
#   display_name = "${var.azure_cluster_name}-app-manager-flink-api-key"
#   description  = "Flink API Key for Azure cluster app manager"
#   owner {
#     id          = confluent_service_account.azure_app_manager.id
#     api_version = confluent_service_account.azure_app_manager.api_version
#     kind        = confluent_service_account.azure_app_manager.kind
#   }
# 
#   managed_resource {
#     id          = confluent_flink_compute_pool.azure_flink_pool[0].id
#     api_version = "fcpm/v2"
#     kind        = "ComputePool"
# 
#     environment {
#       id = var.environment_id
#     }
#   }
# 
#   lifecycle {
#     prevent_destroy = false
#   }
# }
