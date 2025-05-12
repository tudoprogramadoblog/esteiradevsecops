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
                    echo "Tentando executar um comando docker básico..."
                    sh 'docker info' // Ou 'docker version'
                    echo "Construindo a imagem Docker da aplicação Python..."
                    // Construir a imagem Docker da sua aplicação Python
                    def appImage = docker.build("imagem-fastapi:${BUILD_ID}", ".")

                    withCredentials([string(credentialsId: 'Jenkins_CI', variable: 'SONAR_TOKEN')]) {
                        docker.withServer("tcp://sonarqube:9000") {
                            docker.image('sonarsource/sonar-scanner-cli:latest').run("--network minha-rede-compartilhada -v ${WORKSPACE}:/usr/src -e SONAR_HOST_URL=http://sonarqube:9000 -e SONAR_LOGIN=${SONAR_TOKEN} -Dsonar.projectKey=esteiradevsecops -Dsonar.sources=.")
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

                    // Executar o novo container da aplicação
                    docker.run("--name minha-app-fastapi -d --network minha-rede-compartilhada -p 8000:8000 imagem-fastapi:${BUILD_ID}")
                }
            }
        }
    }
}
