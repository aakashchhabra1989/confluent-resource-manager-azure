# Confluent Cloud Infrastructure Configuration for Azure
# This file contains core infrastructure resources: environments
# For Azure cluster and topic definitions, see AZURE/ module

terraform {
  required_version = ">= 1.0"
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "~> 1.0"
    }
  }
}

# Configure the Confluent Provider
provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

# Create a Confluent Cloud Environment
resource "confluent_environment" "main" {
  display_name = var.environment_name

  lifecycle {
    prevent_destroy = false
  }
}

# Azure Cluster and Topics Module
module "azure_cluster" {
  source = "./AZURE"

  # Environment variables
  environment_id            = confluent_environment.main.id
  environment_resource_name = confluent_environment.main.resource_name
  environment_type          = var.environment_type
  sub_environments          = var.sub_environments
  schema_base_path          = var.schema_base_path
  topic_base_prefix         = var.azure_topic_base_prefix

  # Azure cluster variables
  azure_cluster_name         = var.azure_cluster_name
  azure_cluster_availability = var.azure_cluster_availability
  azure_cluster_cloud        = var.azure_cluster_cloud
  azure_cluster_region       = var.azure_cluster_region

  # Flink/Tableflow variables
  flink_max_cfu = var.flink_max_cfu
  enable_flink  = var.enable_flink
}
