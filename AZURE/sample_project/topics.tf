# Azure Topics Module
# This module contains Azure-specific Kafka topic definitions

# Create a Kafka Topic (optional) using Admin API Key for each sub-environment
resource "confluent_kafka_topic" "azure_dummy_topic" {
  for_each = toset(var.sub_environments)

  kafka_cluster {
    id = var.cluster_id
  }
  topic_name       = "${var.topic_prefix}.${each.key}.${local.project_name}.dummy_topic.0"
  partitions_count = 3
  rest_endpoint    = var.cluster_rest_endpoint

  config = {
    "cleanup.policy"      = "delete"
    "delete.retention.ms" = "86400000"
    "max.message.bytes"   = "2097164"
    "min.insync.replicas" = "1"
    "retention.bytes"     = "1073741824"
    "retention.ms"        = "604800000"
    "segment.bytes"       = "104857600"
    "segment.ms"          = "604800000"
  }

  # Use the admin kafka API key for topic operations
  credentials {
    key    = var.admin_kafka_api_key
    secret = var.admin_kafka_api_secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Create a Kafka Topic with Avro Schema for each sub-environment
resource "confluent_kafka_topic" "azure_dummy_topic_with_schema" {
  for_each = toset(var.sub_environments)

  kafka_cluster {
    id = var.cluster_id
  }
  topic_name       = "${var.topic_prefix}.${each.key}.${local.project_name}.dummy_topic_with_schema.0"
  partitions_count = 3
  rest_endpoint    = var.cluster_rest_endpoint

  config = {
    "cleanup.policy"      = "delete"
    "delete.retention.ms" = "86400000"
    "max.message.bytes"   = "2097164"
    "min.insync.replicas" = "1"
    "retention.bytes"     = "1073741824"
    "retention.ms"        = "604800000"
    "segment.bytes"       = "104857600"
    "segment.ms"          = "604800000"
  }

  # Use the admin kafka API key for topic operations
  credentials {
    key    = var.admin_kafka_api_key
    secret = var.admin_kafka_api_secret
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Create HTTP Source Topics for each sub-environment
resource "confluent_kafka_topic" "http_source_topic" {
  for_each = toset(var.sub_environments)

  kafka_cluster {
    id = var.cluster_id
  }

  topic_name       = "${var.topic_prefix}.${each.key}.${local.project_name}.http_source_data.source-connector.0"
  partitions_count = 3
  
  rest_endpoint = var.cluster_rest_endpoint

  credentials {
    key    = var.admin_kafka_api_key
    secret = var.admin_kafka_api_secret
  }

  config = {
    "cleanup.policy"    = "delete"
    "retention.ms"      = "604800000"  # 7 days
    "max.message.bytes" = "1048576"    # 1MB
  }

  lifecycle {
    prevent_destroy = false
  }
}

