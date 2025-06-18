variable "cloud_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
  sensitive   = true
}

variable "cloud_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "cluster_key" {
  description = "Service Account Cluster key"
  type        = string
  sensitive   = true
}

variable "cluster_secret" {
  description = "Service Account Cluster secret"
  type        = string
  sensitive   = true
}

variable "schema_registry_key" {
  description = "Confluent Schema Registry API Key"
  type        = string
  sensitive   = true
}

variable "schema_registry_secret" {
  description = "Confluent Schema Registry API Secret"
  type        = string
  sensitive   = true
}

variable "environment_id" {
  description = "Confluent Environment Id"
  type        = string
  sensitive   = false
}

variable "schema_registry_id" {
  description = "Schema Registry Id"
  type        = string
  sensitive   = false
}

variable "cluster_id" {
  description = "Confluent Cluster Id"
  type        = string
  sensitive   = false
}

variable "topic_name" {
  description = "Topic Name"
  type        = string
  sensitive   = false
}

variable "schema_registry_rest_endpoint" {
  description = "Confluent Schema Registry REST Endpoint"
  type        = string
  sensitive   = false
}

variable "cleanup_policy" {
  description = "Cleanup policy do tópico (ex: delete ou compact)"
  type        = string
  default     = "delete"
}

variable "delete_retention_ms" {
  description = "Tempo de retenção dos tombstones em ms"
  type        = string
  default     = "3600000"
}

variable "max_message_bytes" {
  description = "Tamanho máximo de uma mensagem em bytes"
  type        = string
  default     = "5000000"
}

variable "retention_bytes" {
  description = "Tamanho total máximo que um tópico pode reter em bytes"
  type        = string
  default     = "104857600"
}

variable "retention_ms" {
  description = "Tempo de retenção do tópico em milissegundos"
  type        = string
  default     = "86400000"
}

variable "segment_bytes" {
  description = "Tamanho máximo de um segmento de log em bytes"
  type        = string
  default     = "52428800"
}

variable "segment_ms" {
  description = "Duração máxima de um segmento em milissegundos"
  type        = string
  default     = "86400000"
}

/* Comentadas, mas prontas para uso futuro
variable "message_timestamp_difference_max_ms" {
  description = "Diferença máxima permitida entre timestamps das mensagens"
  type        = string
  default     = "9223372036854775807"
}

variable "message_timestamp_type" {
  description = "Tipo de timestamp (ex: CreateTime)"
  type        = string
  default     = "CreateTime"
}

variable "min_compaction_lag_ms" {
  description = "Lag mínimo para compaction"
  type        = string
  default     = "0"
}

variable "min_insync_replicas" {
  description = "Número mínimo de réplicas in-sync"
  type        = string
  default     = "2"
}

variable "max_compaction_lag_ms" {
  description = "Lag máximo para compaction"
  type        = string
  default     = "9223372036854775807"
}
*/
