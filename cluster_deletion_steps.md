# Azure Cluster Deletion Commands

# Step 1: Remove lifecycle protection from dependent resources (if needed)
# Already done for cluster

# Step 2: Delete resources in dependency order

# Delete topics first (depend on cluster)
terraform destroy -target="module.azure_cluster.confluent_kafka_topic.azure_topics[\"sandbox\"]"

# Delete ACLs (depend on cluster and API keys)
terraform destroy -target="module.azure_cluster.confluent_kafka_acl.azure_app_manager_consumer_group[\"sandbox\"]"
terraform destroy -target="module.azure_cluster.confluent_kafka_acl.azure_app_manager_topic_read[\"sandbox\"]"

# Delete cluster-specific API keys (depend on cluster)
terraform destroy -target="module.azure_cluster.confluent_api_key.azure_admin_manager_kafka_api_key"

# Finally delete the cluster itself
terraform destroy -target="module.azure_cluster.confluent_kafka_cluster.azure_basic"

# What remains:
# - confluent_environment.main (kept)
# - module.azure_cluster.confluent_service_account.azure_admin_manager (kept)
# - module.azure_cluster.confluent_service_account.azure_app_manager (kept)  
