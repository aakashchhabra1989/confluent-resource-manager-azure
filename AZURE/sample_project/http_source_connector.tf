# HTTP Source Connector for Azure
# This file creates HTTP source connectors for data ingestion in Azure environment

# HTTP Source Connector for each sub-environment
resource "confluent_connector" "azure_http_source" {
  for_each = toset(var.sub_environments)

  environment {
    id = var.environment_id
  }
  kafka_cluster {
    id = var.cluster_id
  }

  config_sensitive = {}

  config_nonsensitive = {
    "connector.class"          = "HttpSource"
    "name"                = "HttpSourceConnector_${var.cluster_name}-${each.key}-${local.project_name}"
    "kafka.auth.mode"          = "SERVICE_ACCOUNT"
    "kafka.service.account.id" = var.app_service_account_id
    "url"                      = "https://jsonplaceholder.typicode.com/users"
    "topic.name.pattern"       = confluent_kafka_topic.http_source_topic[each.key].topic_name
    "http.url"                 = "https://jsonplaceholder.typicode.com/users"
    "http.method"              = "GET"
    "http.headers"             = "Content-Type:application/json"
    "http.request.interval.ms" = "60000"
    "http.offset.mode"         = "SIMPLE_INCREMENTING"
    "http.initial.offset"      = "0"
    "kafka.topic"              = "${var.topic_prefix}.${each.key}.${local.project_name}.http_source_data.source-connector.0"
    "output.data.format"       = "JSON"
    "tasks.max"                = "1"
  }

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [
    confluent_kafka_topic.http_source_topic
  ]
}
