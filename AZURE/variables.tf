# Azure Module Variables

# Environment Variables
variable "environment_id" {
  description = "The ID of the Confluent environment"
  type        = string
}

variable "environment_resource_name" {
  description = "The resource name of the Confluent environment"
  type        = string
}

variable "environment_type" {
  description = "Environment type (non-prod, prod, sandbox)"
  type        = string
  default     = "non-prod"
}

variable "sub_environments" {
  description = "List of sub-environments to create resources for"
  type        = list(string)
  default     = ["dev"]
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

variable "topic_base_prefix" {
  description = "Base prefix for topic names"
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
  description = "The cloud service provider where the Kafka cluster will be created"
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


