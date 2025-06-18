pipeline {
    agent any

    parameters {
    string(name: 'TOPIC_NAME', defaultValue: 'topico-jenkins', description: 'Nome do tópico Kafka')
    string(name: 'DELETE_RETENTION_MS', defaultValue: '604800000', description: 'Tempo para deleção da retenção em milissegundos (padrão: 7 dias)')
    string(name: 'RETENTION_MS', defaultValue: '86400000', description: 'Tempo de retenção em milissegundos (padrão: 1 dia)')
    string(name: 'RETENTION_BYTES', defaultValue: '104857600', description: 'Tempo de retenção em milissegundos (padrão: 104Mb)')
    string(name: 'SEGMENT_MS', defaultValue: '86400000', description: 'Tempo de retenção em milissegundos (padrão: 1 dia)')
    string(name: 'SEGMENT_BYTES', defaultValue: '52428800', description: 'Tempo de retenção em milissegundos (padrão: 52Mb)')
    string(name: 'CLEANUP_POLICY', defaultValue: 'delete', description: 'Política de limpeza (delete, compact)')
    string(name: 'MAX_MESSAGE_BYTES', defaultValue: '5000000', description: 'Tamanho máximo de mensagem em bytes')
    string(name: 'ENVIRONMENT_ID', defaultValue: 'lkc-6xxy82', description: 'Id do cluster')
    string(name: 'CLUSTER_ID', defaultValue: 'env-qzn062', description: 'Id do environment')
    string(name: 'SCHEMA_REGISTRY_ID', defaultValue: 'lsrc-yjjk2j', description: 'Id do schema registry')
    string(name: 'SCHEMA_REST_ENDPOINT', defaultValue: 'https://psrc-q8w9z6.us-central1.gcp.confluent.cloud', description: 'REST Endpoint do schema registry')
}


    environment {
        TF_VAR_confluent_cloud_api_key       = credentials('CONFLUENT_CLOUD_KEY')
        TF_VAR_confluent_cloud_api_secret    = credentials('CONFLUENT_CLOUD_KEY')  // se key:secret estiver juntos
        TF_VAR_cluster_key                   = credentials('CONFLUENT_SHARED_DES_CLUSTER')  // pode separar se quiser
        TF_VAR_cluster_secret                = credentials('CONFLUENT_SHARED_DES_CLUSTER')
        TF_VAR_schema_registry_api_key       = credentials('CONFLUENT_SHARED_DES_SCHEMA')
        TF_VAR_schema_registry_api_secret    = credentials('CONFLUENT_SHARED_DES_SCHEMA')
    }

    stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'git@github.com:ribeirohenrique/infra-as-code.git'
      }
    }

    stage('Terraform Init') {
      steps {
        sh 'terraform init'
      }
    }

    stage('Generate tfvars') {
      steps {
        writeFile file: 'terraform.tfvars', text: """
          cloud_key    = "${env.TF_VAR_confluent_cloud_api_key}"
          cloud_secret = "${env.TF_VAR_confluent_cloud_api_secret}"
          cluster_key = "${env.TF_VAR_cluster_key}"
          cluster_secret = "${env.TF_VAR_cluster_secret}"
          schema_registry_key = "${env.TF_VAR_schema_registry_api_key}"
          schema_registry_secret = "${env.TF_VAR_schema_registry_api_secret}"
          environment_id = "${params.ENVIRONMENT_ID}"
          schema_registry_id = "${params.SCHEMA_REGISTRY_ID}"
          cluster_id = "${params.CLUSTER_ID}"
          topic_name = "${params.TOPIC_NAME}"
          schema_registry_rest_endpoint = "${params.SCHEMA_REST_ENDPOINT}"
          cleanup_policy = "${params.CLEANUP_POLICY}"
          delete_retention_ms = "${params.DELETE_RETENTION_MS}"
          max_message_bytes = "${params.MAX_MESSAGE_BYTES}"
          retention_bytes = "${params.RETENTION_BYTES}"
          retention_ms = "${params.RETENTION_MS}"
          segment_bytes = "${params.SEGMENT_BYTES}"
          segment_ms = "${params.SEGMENT_MS}"
        """
      }
    }

    stage('Terraform Plan') {
      steps {
        sh 'terraform plan -var-file="terraform.tfvars" -out=tfplan'
      }
    }

    stage('Terraform Apply') {
      steps {
        input message: 'Deseja aplicar as mudanças?'
        sh 'terraform apply tfplan'
      }
    }
    }

    post {
        always {
            archiveArtifacts artifacts: 'topics/*.tfvars', fingerprint: true
        }
    }
}
