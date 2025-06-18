pipeline {
    agent any

    environment {
        TF_CLI_ARGS = "-no-color"
    }

    parameters {
        string(name: 'TOPIC_NAME', defaultValue: 'topico-jenkins', description: 'Nome do tópico Kafka')
        string(name: 'DELETE_RETENTION_MS', defaultValue: '604800000', description: 'Tempo para deleção da retenção em milissegundos (padrão: 7 dias)')
        string(name: 'RETENTION_MS', defaultValue: '86400000', description: 'Tempo de retenção em milissegundos (padrão: 1 dia)')
        string(name: 'RETENTION_BYTES', defaultValue: '104857600', description: 'Tempo de retenção em milissegundos (padrão: 104Mb)')
        string(name: 'SEGMENT_MS', defaultValue: '86400000', description: 'Tempo de retenção em milissegundos (padrão: 1 dia)')
        string(name: 'SEGMENT_BYTES', defaultValue: '52428800', description: 'Tempo de retenção em milissegundos (padrão: 52Mb)')
        string(name: 'CLEANUP_POLICY', defaultValue: 'delete', description: 'Política de limpeza (delete, compact)')
        string(name: 'MAX_MESSAGE_BYTES', defaultValue: '5000000', description: 'Tamanho máximo de mensagem em bytes')
        string(name: 'CLUSTER_ID', defaultValue: 'lkc-6xxy82', description: 'Id do cluster')
        string(name: 'ENVIRONMENT_ID', defaultValue: 'env-qzn062', description: 'Id do environment')
        string(name: 'SCHEMA_REGISTRY_ID', defaultValue: 'lsrc-yjjk2j', description: 'Id do schema registry')
        string(name: 'SCHEMA_REST_ENDPOINT', defaultValue: 'https://psrc-q8w9z6.us-central1.gcp.confluent.cloud', description: 'REST Endpoint do schema registry')
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'git@github.com:ribeirohenrique/infra-as-code.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'cd topics && terraform init'
            }
        }

        stage('Generate tfvars') {
            steps {
                withCredentials([
                        usernamePassword(credentialsId: 'CONFLUENT_CLOUD', usernameVariable: 'CLOUD_KEY', passwordVariable: 'CLOUD_SECRET'),
                        usernamePassword(credentialsId: 'SHARED_DES_SCHEMA', usernameVariable: 'SCHEMA_KEY', passwordVariable: 'SCHEMA_SECRET'),
                        usernamePassword(credentialsId: 'SHARED_DES_CLUSTER', usernameVariable: 'CLUSTER_KEY', passwordVariable: 'CLUSTER_SECRET'),
                ]) {
                    script {
                        def tfvarsContent = """
cloud_key = "${CLOUD_KEY}"
cloud_secret = "${CLOUD_SECRET}"
cluster_key = "${CLUSTER_KEY}"
cluster_secret = "${CLUSTER_SECRET}"
schema_registry_key = "${SCHEMA_KEY}"
schema_registry_secret = "${SCHEMA_SECRET}"
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
                        writeFile file: 'topics/terraform.tfvars', text: tfvarsContent
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'cd topics && terraform plan -var-file="terraform.tfvars" -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Deseja aplicar as mudanças?'
                sh 'cd topics && terraform apply tfplan'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'topics/*.tfvars', fingerprint: true
        }
    }
}
