# Azure Sample Project Module Outputs

# Topic Outputs
output "azure_dummy_topic_names" {
  description = "Names of the Azure dummy topics"
  value       = [for topic in confluent_kafka_topic.azure_dummy_topic : topic.topic_name]
}

output "azure_dummy_topic_with_schema_names" {
  description = "Names of the Azure dummy topics with schema"
  value       = [for topic in confluent_kafka_topic.azure_dummy_topic_with_schema : topic.topic_name]
}

output "azure_http_source_topic_names" {
  description = "Names of the Azure HTTP source topics"
  value       = [for topic in confluent_kafka_topic.http_source_topic : topic.topic_name]
}

# Removed user_profile and user_activity topic outputs as they were removed from topics.tf

# Schema Outputs (disabled when Schema Registry is not available)
# output "azure_dummy_topic_key_schema_ids" {
#   description = "IDs of the Azure dummy topic key schemas"
#   value       = [for schema in confluent_schema.azure_dummy_topic_key_schema : schema.id]
# }

# output "azure_dummy_topic_value_schema_ids" {
#   description = "IDs of the Azure dummy topic value schemas"
#   value       = [for schema in confluent_schema.azure_dummy_topic_value_schema : schema.id]
# }

# output "azure_user_profile_key_schema_ids" {
#   description = "IDs of the Azure user profile key schemas"
#   value       = [for schema in confluent_schema.azure_user_profile_key_schema : schema.id]
# }

# output "azure_user_profile_value_schema_ids" {
#   description = "IDs of the Azure user profile value schemas"
#   value       = [for schema in confluent_schema.azure_user_profile_value_schema : schema.id]
# }

output "azure_schema_ids" {
  description = "Placeholder for schema IDs (disabled when SR is not available)"
  value       = []
}

# Connector Outputs
# output "azure_http_source_connector_names" {
#   description = "Names of the Azure HTTP source connectors"
#   value       = [for connector in confluent_connector.azure_http_source : connector.id]
# }

# Flink Outputs (DISABLED - statements removed due to API key limitations)
# output "azure_flink_user_table_statements" {
#   description = "IDs of the Azure Flink user table statements"
#   value       = var.enable_flink ? [for statement in confluent_flink_statement.azure_create_user_table : statement.id] : []
# }
# 
# output "azure_flink_advanced_processing_statements" {
#   description = "IDs of the Azure Flink advanced processing statements"
#   value       = var.enable_flink ? [for statement in confluent_flink_statement.azure_advanced_user_processing : statement.id] : []
# }
# 
# output "azure_flink_stream_processing_statements" {
#   description = "IDs of the Azure Flink stream processing statements"
#   value       = var.enable_flink ? [for statement in confluent_flink_statement.azure_user_activity_stream : statement.id] : []
# }
