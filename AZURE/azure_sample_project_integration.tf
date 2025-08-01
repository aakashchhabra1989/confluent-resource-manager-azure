# Azure Sample Project Integration
# This file integrates with the sample project module for Azure-specific configurations

# Call the sample project module with Azure cluster configuration
module "azure_sample_project" {
  source = "./sample_project"

  # Environment configuration
  environment_id            = var.environment_id
  environment_resource_name = var.environment_resource_name
  environment_type          = var.environment_type
  sub_environments          = var.sub_environments
  project_name              = "sample_project" # Hardcoded for this module
  schema_base_path          = var.schema_base_path

  # Azure cluster configuration
  cluster_id               = confluent_kafka_cluster.azure_basic.id
  cluster_bootstrap_endpoint = confluent_kafka_cluster.azure_basic.bootstrap_endpoint
  cluster_rest_endpoint    = confluent_kafka_cluster.azure_basic.rest_endpoint
  cluster_name            = var.azure_cluster_name
  cluster_cloud           = var.azure_cluster_cloud
  cluster_region          = var.azure_cluster_region

  # Service accounts
  admin_service_account_id = confluent_service_account.azure_admin_manager.id
  app_service_account_id   = confluent_service_account.azure_app_manager.id

  # API Keys
  admin_kafka_api_key    = confluent_api_key.azure_admin_manager_kafka_api_key.id
  admin_kafka_api_secret = confluent_api_key.azure_admin_manager_kafka_api_key.secret
  app_kafka_api_key      = confluent_api_key.azure_app_manager_kafka_api_key.id
  app_kafka_api_secret   = confluent_api_key.azure_app_manager_kafka_api_key.secret

  # Schema Registry (disabled when SR is not available)
  # schema_registry_id           = data.confluent_schema_registry_cluster.azure_essentials.id
  # schema_registry_rest_endpoint = data.confluent_schema_registry_cluster.azure_essentials.rest_endpoint
  # schema_registry_api_key      = confluent_api_key.azure_admin_schema_registry_api_key.id
  # schema_registry_api_secret   = confluent_api_key.azure_admin_schema_registry_api_key.secret
  schema_registry_id           = "" # Disabled for basic deployment
  schema_registry_rest_endpoint = "" # Disabled for basic deployment
  schema_registry_api_key      = "" # Disabled for basic deployment
  schema_registry_api_secret   = "" # Disabled for basic deployment

  # Flink configuration (conditional)
  enable_flink             = var.enable_flink
  flink_compute_pool_id    = var.enable_flink ? confluent_flink_compute_pool.azure_flink_pool[0].id : null
  flink_rest_endpoint      = var.enable_flink ? "https://flink.${var.azure_cluster_region}.azure.confluent.cloud" : null
  flink_admin_api_key      = var.enable_flink ? confluent_api_key.azure_admin_manager_kafka_api_key.id : null
  flink_admin_api_secret   = var.enable_flink ? confluent_api_key.azure_admin_manager_kafka_api_key.secret : null
  flink_app_api_key        = var.enable_flink ? confluent_api_key.azure_app_manager_kafka_api_key.id : null
  flink_app_api_secret     = var.enable_flink ? confluent_api_key.azure_app_manager_kafka_api_key.secret : null

  # Topic prefix for Azure
  topic_prefix = var.topic_base_prefix
}
