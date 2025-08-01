# Confluent Cloud API Credentials
variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key"
  type        = string
  sensitive   = true
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

# Environment Configuration
variable "environment_name" {
  description = "Name for the Confluent Environment"
  type        = string
  default     = "terraform-env"
}

variable "environment_type" {
  description = "Environment type (non-prod, prod, sandbox)"
  type        = string
  default     = "non-prod"
  validation {
    condition     = contains(["non-prod", "prod", "sandbox"], var.environment_type)
    error_message = "Environment type must be either 'non-prod', 'prod', or 'sandbox'."
  }
}

variable "sub_environments" {
  description = "List of sub-environments to create resources for"
  type        = list(string)
  default     = ["dev"]
  validation {
    condition = alltrue([
      for env in var.sub_environments : contains(["dev", "qa", "uat", "prod", "sandbox"], env)
    ])
    error_message = "Sub-environments must be from: dev, qa, uat, prod, sandbox."
  }
}

variable "project_name" {
  description = "Project name to be included in resource naming"
  type        = string
  default     = "sample_project"
}

variable "schema_base_path" {
  description = "Base path for schema files"
  type        = string
  default     = "schemas"
}

# Azure Kafka Cluster Configuration
variable "default_topic_partition" {
  description = "Number of partitions for the example topic"
  type        = number
  default     = 3
  validation {
    condition     = var.default_topic_partition > 0
    error_message = "Topic partitions must be greater than 0."
  }
}

# Flink/Tableflow Configuration
variable "flink_max_cfu" {
  description = "Maximum Confluent Flink Units for the compute pool"
  type        = number
  default     = 5
}

variable "enable_flink" {
  description = "Enable Flink compute pool for Tableflow"
  type        = bool
  default     = true
}

# Azure Topic Configuration
variable "azure_topic_base_prefix" {
  description = "Base prefix for Azure topic names"
  type        = string
  default     = "azure.sampleproject"
}

# Azure Kafka Cluster Configuration
variable "azure_cluster_name" {
  description = "Name for the Azure Kafka cluster"
  type        = string
  default     = "azure-terraform-cluster"
}

variable "azure_cluster_availability" {
  description = "The availability zone configuration of the Azure Kafka cluster"
  type        = string
  default     = "SINGLE_ZONE"
  validation {
    condition     = contains(["SINGLE_ZONE", "MULTI_ZONE"], var.azure_cluster_availability)
    error_message = "Availability must be either 'SINGLE_ZONE' or 'MULTI_ZONE'."
  }
}

variable "azure_cluster_cloud" {
  description = "The cloud service provider where the Azure Kafka cluster will be created"
  type        = string
  default     = "AZURE"
  validation {
    condition     = contains(["AWS", "GCP", "AZURE"], var.azure_cluster_cloud)
    error_message = "Cloud must be one of 'AWS', 'GCP', or 'AZURE'."
  }
}

variable "azure_cluster_region" {
  description = "The Azure region where the Kafka cluster will be created"
  type        = string
  default     = "eastus"
  validation {
    condition = contains([
      "eastus", "eastus2", "westus", "westus2", "westus3", "centralus",
      "northcentralus", "southcentralus", "westcentralus", "canadacentral",
      "canadaeast", "brazilsouth", "northeurope", "westeurope", "uksouth",
      "ukwest", "francecentral", "francesouth", "germanywestcentral",
      "norwayeast", "switzerlandnorth", "uaenorth", "southafricanorth",
      "australiaeast", "australiasoutheast", "southeastasia", "eastasia",
      "japaneast", "japanwest", "koreacentral", "koreasouth", "centralindia",
      "southindia", "westindia"
    ], var.azure_cluster_region)
    error_message = "Must be a valid Azure region supported by Confluent Cloud."
  }
}


