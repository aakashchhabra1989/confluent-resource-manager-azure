# Terraform and Provider Version Requirements for Azure Sample Project

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "~> 1.0"
    }
  }
}
