# Azure Sample Project Module Variables
# All variables needed for the sample project resources in Azure

variable "project_name" {
  description = "Project name to be included in resource naming"
  type        = string
  default     = "sample_project"
}

# Project name is hardcoded for this module
locals {
  project_name = var.project_name
}

variable "environment_id" {
  description = "The ID of the Confluent Environment"
  type        = string
}

variable "environment_resource_name" {
  description = "The resource name of the Confluent Environment"
  type        = string
}

variable "environment_type" {
  description = "The type of environment (prod, non-prod, or sandbox)"
  type        = string
}

variable "sub_environments" {
  description = "List of sub-environments to create resources for"
  type        = list(string)
}

variable "schema_base_path" {
  description = "Base path for schema files"
  type        = string
  default     = "schemas"
}

# Azure Cluster Configuration
variable "cluster_id" {
  description = "The ID of the Azure Kafka cluster"
  type        = string
}

variable "cluster_bootstrap_endpoint" {
  description = "The bootstrap endpoint of the Azure Kafka cluster"
  type        = string
}

variable "cluster_rest_endpoint" {
  description = "The REST endpoint of the Azure Kafka cluster"
  type        = string
}

variable "cluster_name" {
  description = "Name of the Azure Kafka cluster"
  type        = string
}

variable "cluster_region" {
  description = "Azure region for the cluster"
  type        = string
}

variable "cluster_cloud" {
  description = "Cloud provider (AZURE)"
  type        = string
  default     = "AZURE"
}

# Service Account Configuration
variable "admin_service_account_id" {
  description = "The ID of the admin service account"
  type        = string
}

variable "app_service_account_id" {
  description = "The ID of the app service account"
  type        = string
}

# API Keys Configuration
variable "admin_kafka_api_key" {
  description = "The Kafka API key for admin operations"
  type        = string
  sensitive   = true
}

variable "admin_kafka_api_secret" {
  description = "The Kafka API secret for admin operations"
  type        = string
  sensitive   = true
}

variable "app_kafka_api_key" {
  description = "The Kafka API key for application operations"
  type        = string
  sensitive   = true
}

variable "app_kafka_api_secret" {
  description = "The Kafka API secret for application operations"
  type        = string
  sensitive   = true
}

# Schema Registry Configuration
variable "schema_registry_id" {
  description = "The ID of the Schema Registry cluster"
  type        = string
}

variable "schema_registry_rest_endpoint" {
  description = "The REST endpoint of the Schema Registry cluster"
  type        = string
}

variable "schema_registry_api_key" {
  description = "The Schema Registry API key"
  type        = string
  sensitive   = true
}

variable "schema_registry_api_secret" {
  description = "The Schema Registry API secret"
  type        = string
  sensitive   = true
}

# Flink Configuration
variable "enable_flink" {
  description = "Whether Flink is enabled"
  type        = bool
  default     = false
}

variable "flink_compute_pool_id" {
  description = "The ID of the Flink compute pool"
  type        = string
  default     = null
}

variable "flink_rest_endpoint" {
  description = "The REST endpoint of the Flink compute pool"
  type        = string
  default     = null
}

variable "flink_admin_api_key" {
  description = "The Flink API key for admin operations"
  type        = string
  sensitive   = true
  default     = null
}

variable "flink_admin_api_secret" {
  description = "The Flink API secret for admin operations"
  type        = string
  sensitive   = true
  default     = null
}

variable "flink_app_api_key" {
  description = "The Flink API key for application operations"
  type        = string
  sensitive   = true
  default     = null
}

variable "flink_app_api_secret" {
  description = "The Flink API secret for application operations"
  type        = string
  sensitive   = true
  default     = null
}

# Topic Configuration
variable "topic_prefix" {
  description = "Prefix for topic naming"
  type        = string
  default     = "azure.sample_project"
}


