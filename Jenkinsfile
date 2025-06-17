pipeline {
    agent any

    parameters {
    string(name: 'TOPIC_NAME', defaultValue: 'topico-jenkins', description: 'Nome do tópico Kafka')
    string(name: 'RETENTION_MS', defaultValue: '604800000', description: 'Tempo de retenção em milissegundos (padrão: 7 dias)')
    string(name: 'CLEANUP_POLICY', defaultValue: 'delete', description: 'Política de limpeza (delete, compact)')
    string(name: 'MAX_MESSAGE_BYTES', defaultValue: '5000000', description: 'Tamanho máximo de mensagem em bytes')
}


    environment {
        TF_VAR_confluent_cloud_api_key       = credentials('CONFLUENT_CLOUD_KEY')
        TF_VAR_confluent_cloud_api_secret    = credentials('CONFLUENT_CLOUD_KEY')  // se key:secret estiver juntos
        TF_VAR_service_account_cluster_key   = credentials('CONFLUENT_CLOUD_KEY')  // pode separar se quiser
        TF_VAR_service_account_cluster_secret= credentials('CONFLUENT_CLOUD_KEY')
        TF_VAR_cluster_id                    = credentials('CONFLUENT_SHARED_DES_CLUSTER')
        TF_VAR_schema_registry_id            = credentials('CONFLUENT_SHARED_DES_SCHEMA')
        TF_VAR_schema_registry_api_key       = credentials('CONFLUENT_CLOUD_KEY')
        TF_VAR_schema_registry_api_secret    = credentials('CONFLUENT_CLOUD_KEY')
        TF_VAR_environment_id                = 'env-xxxxx'  // Substitua pelo seu
        TF_VAR_schema_registry_rest_endpoint = 'https://xxxx.gcp.confluent.cloud' // Substitua pelo seu endpoint
        TF_VAR_tag_name                      = 'created-by-jenkins'
    }

    stages {
        stage('Clone Repo') {
            steps {
                git url: 'git@github.com:ribeirohenrique/infra-as-code.git', branch: 'main'
            }
        }

        stage('Init Terraform') {
            steps {
                dir('topics') {
                    sh 'terraform init'
                }
            }
        }

        stage('Create tfvars') {
            steps {
                dir('topics') {
                    writeFile file: 'jenkins.auto.tfvars', text: """
topic_name           = "${params.TOPIC_NAME}"
tag_name             = "created-by-jenkins"
retention_ms         = "${params.RETENTION_MS}"
cleanup_policy       = "${params.CLEANUP_POLICY}"
max_message_bytes    = "${params.MAX_MESSAGE_BYTES}"
"""

                    echo "Arquivo jenkins.auto.tfvars criado para ${params.TOPIC_NAME}"
                }
            }
        }

        stage('Override retention') {
            steps {
                dir('topics') {
                    script {
                        sh """
                        sed -i 's/"retention.ms" *= *"[^"]*"/"retention.ms" = "${params.RETENTION_MS}"/' main.tf
                        """
                    }
                }
            }
        }

        stage('Plan') {
            steps {
                dir('topics') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Apply') {
            steps {
                input message: "Deseja aplicar a criação do tópico '${params.TOPIC_NAME}' com retenção ${params.RETENTION_MS}ms?"
                dir('topics') {
                    sh 'terraform apply tfplan'
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'topics/*.tfvars', fingerprint: true
        }
    }
}
