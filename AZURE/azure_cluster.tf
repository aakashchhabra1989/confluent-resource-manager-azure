# Azure Cluster Creation Module
# This file contains Azure-specific Confluent Kafka cluster and related resources

terraform {
  required_providers {
    confluent = {
      source = "confluentinc/confluent"
    }
  }
}

# Create a Basic Kafka Cluster in Azure
resource "confluent_kafka_cluster" "azure_basic" {
  display_name = var.azure_cluster_name
  availability = var.azure_cluster_availability
  cloud        = var.azure_cluster_cloud
  region       = var.azure_cluster_region
  basic {}

  environment {
    id = var.environment_id
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Create a Service Account for the Azure Kafka cluster
resource "confluent_service_account" "azure_app_manager" {
  display_name = "${var.azure_cluster_name}-app-manager"
  description  = "Service account to manage Azure Kafka cluster ${var.azure_cluster_name}"

  lifecycle {
    prevent_destroy = false
  }
}

# Create an Admin Service Account for ACL management
resource "confluent_service_account" "azure_admin_manager" {
  display_name = "${var.azure_cluster_name}-admin-manager"
  description  = "Admin service account for ACL management in Azure cluster ${var.azure_cluster_name}"

  lifecycle {
    prevent_destroy = false
  }
}

# Create role binding for admin service account (Environment Admin)
resource "confluent_role_binding" "azure_admin_environment_admin" {
  principal   = "User:${confluent_service_account.azure_admin_manager.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = var.environment_resource_name
}

# Create role binding for admin service account (Flink Admin)
resource "confluent_role_binding" "azure_admin_flink_admin" {
  principal   = "User:${confluent_service_account.azure_admin_manager.id}"
  role_name   = "FlinkAdmin"
  crn_pattern = var.environment_resource_name
}

# Create API Key for the service account
resource "confluent_api_key" "azure_app_manager_kafka_api_key" {
  display_name = "${var.azure_cluster_name}-app-manager-kafka-api-key"
  description  = "Kafka API Key that is owned by '${confluent_service_account.azure_app_manager.display_name}' service account for Azure cluster"
  owner {
    id          = confluent_service_account.azure_app_manager.id
    api_version = confluent_service_account.azure_app_manager.api_version
    kind        = confluent_service_account.azure_app_manager.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.azure_basic.id
    api_version = confluent_kafka_cluster.azure_basic.api_version
    kind        = confluent_kafka_cluster.azure_basic.kind

    environment {
      id = var.environment_id
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Create API Key for the admin service account
resource "confluent_api_key" "azure_admin_manager_kafka_api_key" {
  display_name = "${var.azure_cluster_name}-admin-manager-kafka-api-key"
  description  = "Kafka API Key that is owned by '${confluent_service_account.azure_admin_manager.display_name}' service account for Azure cluster"
  owner {
    id          = confluent_service_account.azure_admin_manager.id
    api_version = confluent_service_account.azure_admin_manager.api_version
    kind        = confluent_service_account.azure_admin_manager.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.azure_basic.id
    api_version = confluent_kafka_cluster.azure_basic.api_version
    kind        = confluent_kafka_cluster.azure_basic.kind

    environment {
      id = var.environment_id
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Grant role bindings to the service account for cluster management
resource "confluent_role_binding" "azure_app_manager_cluster_admin" {
  principal   = "User:${confluent_service_account.azure_app_manager.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.azure_basic.rbac_crn
}

# Create Schema Registry API Key for admin account (disabled when SR is not available)
# resource "confluent_api_key" "azure_admin_schema_registry_api_key" {
#   display_name = "${var.azure_cluster_name}-admin-schema-registry-api-key"
#   description  = "Schema Registry API Key for Azure cluster admin"
#   owner {
#     id          = confluent_service_account.azure_admin_manager.id
#     api_version = confluent_service_account.azure_admin_manager.api_version
#     kind        = confluent_service_account.azure_admin_manager.kind
#   }
#   # NOTE: Schema Registry API key creation disabled when Schema Registry is not available
#   # managed_resource {
#   #   id          = data.confluent_schema_registry_cluster.azure_essentials.id
#   #   api_version = data.confluent_schema_registry_cluster.azure_essentials.api_version
#   #   kind        = data.confluent_schema_registry_cluster.azure_essentials.kind
#   #   environment {
#   #     id = var.environment_id
#   #   }
#   # }
#
#   lifecycle {
#     prevent_destroy = false
#   }
# }

# Get Schema Registry cluster for the environment
# NOTE: Schema Registry may not be available in all environments/regions
# Commenting out to allow basic cluster deployment
# data "confluent_schema_registry_cluster" "azure_essentials" {
#   environment {
#     id = var.environment_id
#   }
# }

# Grant Schema Registry permissions to admin
# resource "confluent_role_binding" "azure_admin_schema_registry_resource_owner" {
#   principal   = "User:${confluent_service_account.azure_admin_manager.id}"
#   role_name   = "DeveloperWrite"
#   crn_pattern = data.confluent_schema_registry_cluster.azure_essentials.resource_name
# }
