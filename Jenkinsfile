pipeline {
    agent any

    environment {
        SONAR_HOST = 'http://sonarqube:9000'
        SONAR_PROJECT_KEY = 'esteiradevsecops'
        DOCKER_IMAGE_TAG = "imagem-fastapi:${BUILD_ID}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Testes') {
            steps {
                sh 'python -m unittest discover'
            }
        }

        stage('SonarQube') {
            steps {
                withCredentials([string(credentialsId: 'Jenkins_CI', variable: 'SONAR_TOKEN')]) {
                    docker.image('sonarsource/sonar-scanner-cli:latest').inside("--network minha-rede-compartilhada -v ${WORKSPACE}:/usr/src") {
                        sh """
                            sonar-scanner \
                                -Dsonar.host.url=${SONAR_HOST} \
                                -Dsonar.login=${SONAR_TOKEN} \
                                -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                                -Dsonar.sources=.
                        """
                    }
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    appImage = docker.build(env.DOCKER_IMAGE_TAG)
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh 'docker stop minha-app-fastapi || true'
                    sh 'docker rm minha-app-fastapi || true'
                    docker.image(env.DOCKER_IMAGE_TAG).run("--name minha-app-fastapi -d --network minha-rede-compartilhada -p 8000:8000")
                }
            }
        }
    }
}
