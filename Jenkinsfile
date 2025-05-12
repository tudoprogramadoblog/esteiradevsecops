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
            agent {
                docker {
                    image 'python:3.10'
                }
            }
            steps {
                sh 'pip install -r requirements.txt || true' // opcional
                sh 'python -m unittest discover'
            }
        }


        stage('SonarQube') {
            steps {
                script {
                    echo 'Executando análise com SonarQube...'
                    withCredentials([string(credentialsId: 'Jenkins_CI', variable: 'SONAR_TOKEN')]) {
                        def scannerImage = docker.image('sonarsource/sonar-scanner-cli:latest')
                        scannerImage.inside("-v ${env.WORKSPACE}:/usr/src -w /usr/src --network host") {
                            sh """
                                sonar-scanner \
                                    -Dsonar.projectKey=${env.SONAR_PROJECT_KEY} \
                                    -Dsonar.sources=. \
                                    -Dsonar.host.url=${env.SONAR_HOST} \
                                    -Dsonar.login=${env.SONAR_TOKEN}
                            """
                        }
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
