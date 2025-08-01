-- Create Sink Table for User Registration Count Results
-- This SQL creates a sink table to write daily user registration counts back to Kafka

CREATE TABLE tbl_${project_name}_daily_user_registration_sink (
  registration_date STRING,
  user_count BIGINT,
  calculation_timestamp TIMESTAMP(3)
) WITH (
  'connector' = 'confluent-kafka',
  'kafka.bootstrap.servers' = '${bootstrap_servers}',
  'topic' = '${topic_name_prefix}.${project_name}.daily_user_registration_counts',
  'value.format' = 'json'
);
