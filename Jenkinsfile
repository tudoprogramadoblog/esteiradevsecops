pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build e Teste') {
            steps {
                script {
                    // Construir a imagem Docker da sua aplicação Python
                    def appImage = docker.build("imagem-fastapi:${BUILD_ID}", ".")

                    withCredentials([string(credentialsId: 'Jenkins_CI', variable: 'SONAR_TOKEN')]) {
                        // Executar o scanner SonarQube como um container Docker gerenciado pelo plugin
                        docker.image('sonarsource/sonar-scanner-cli:latest').inside("--network minha-rede-compartilhada -v ${WORKSPACE}:/usr/src") {
                            sh "sonar-scanner -Dsonar.host.url=http://sonarqube:9000 -Dsonar.login=${SONAR_TOKEN} -Dsonar.projectKey=esteiradevsecops -Dsonar.sources=."
                        }
                    }

                    // Executar outros testes unitários (se houver)
                    sh 'python -m unittest discover'
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Para o CD local, podemos simplesmente parar e remover o container antigo
                    sh 'docker stop minha-app-fastapi && docker rm minha-app-fastapi'

                    // Executar o novo container da aplicação usando o plugin
                    docker.run("--name minha-app-fastapi -d --network minha-rede-compartilhada -p 8000:8000 ${appImage.id}")
                }
            }
        }
    }
}