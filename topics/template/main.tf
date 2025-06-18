terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
    }
  }
}

//Define a Cloud API Key criada anteriormente
provider "confluent" {
  cloud_api_key                 = var.cloud_key
  cloud_api_secret              = var.cloud_secret
  schema_registry_id            = var.schema_registry_id            # optionally use SCHEMA_REGISTRY_ID env var
  schema_registry_rest_endpoint = var.schema_registry_rest_endpoint # optionally use SCHEMA_REGISTRY_REST_ENDPOINT env var
  schema_registry_api_key       = var.schema_registry_key       # optionally use SCHEMA_REGISTRY_API_KEY env var
  schema_registry_api_secret    = var.schema_registry_secret    # optionally use SCHEMA_REGISTRY_API_SECRET env var
}

//Define o Cluster a ser utilizado
data "confluent_kafka_cluster" "confluent_cluster" {
  id = var.cluster_id
  environment {
    id = var.environment_id
  }
}

//Cria um tópico para gravar mensagens
resource "confluent_kafka_topic" "confluent_topic" {
  kafka_cluster {
    id = var.cluster_id
  }
  topic_name       = var.topic_name
  rest_endpoint    = data.confluent_kafka_cluster.confluent_cluster.rest_endpoint
  partitions_count = 2

  config = {
    "cleanup.policy"           = var.cleanup_policy
    "delete.retention.ms"      = var.delete_retention_ms
    "max.message.bytes"        = var.max_message_bytes
    "retention.bytes"          = var.retention_bytes
    "retention.ms"             = var.retention_ms
    "segment.bytes"            = var.segment_bytes
    "segment.ms"               = var.segment_ms
    # "message.timestamp.difference.max.ms" = var.message_timestamp_difference_max_ms
    # "message.timestamp.type"              = var.message_timestamp_type
    # "min.compaction.lag.ms"               = var.min_compaction_lag_ms
    # "min.insync.replicas"                 = var.min_insync_replicas
    # "max.compaction.lag.ms"               = var.max_compaction_lag_ms
  }

  credentials {
    key    = var.cluster_key
    secret = var.cluster_secret
  }

  lifecycle {
    prevent_destroy = true
  }
}
