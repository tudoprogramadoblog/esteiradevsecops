pipeline {
    agent any

    environment {
        SONAR_HOST = 'http://sonarqube:9000'
        SONAR_PROJECT_KEY = 'esteiradevsecops'
        DOCKER_IMAGE_TAG = "imagem-fastapi:${BUILD_ID}"
        SONAR_TOKEN = credentials('SONAR_TOKEN') // Certifique-se que este ID está correto no Jenkins
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
                    args '-u root' // executa como root
                }
            }
            steps {
                sh 'python -m pip install --upgrade pip'
                sh 'pip install -r app/requirements.txt || true'
                sh 'python -m unittest discover -s app/tests -p "*.py"'
                sh 'coverage run -m pytest app/tests'
                sh 'coverage xml' // Gera coverage.xml para o SonarQube
            }
        }

        stage('SonarQube') {
            steps {
                script {
                    echo 'Executando análise com SonarQube...'
                    withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
                        withSonarQubeEnv('SonarQube') {
                            sh """
                                sonar-scanner \
                                -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                                -Dsonar.sources=app \
                                -Dsonar.python.coverage.reportPaths=coverage.xml \
                                -Dsonar.host.url=${SONAR_HOST} \
                                -Dsonar.login=${SONAR_TOKEN}
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
                    docker.image(env.DOCKER_IMAGE_TAG).run(
                        "--name minha-app-fastapi -d --network minha-rede-compartilhada -p 8000:8000 -v /var/run/docker.sock:/var/run/docker.sock"
                    )
                }
            }
        }
    }
}