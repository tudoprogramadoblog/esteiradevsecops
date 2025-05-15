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
                    args '-u root' // executa como root
                }
            }
            steps {
                sh 'python -m pip install --upgrade pip'
                sh 'pip install -r app/requirements.txt || true'
                // Rodar os testes com pytest e cobertura de código
                sh 'coverage run -m pytest app/tests --maxfail=5 --disable-warnings -q'
                // Gerar o arquivo coverage.xml para o SonarQube
                sh 'coverage xml'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("SonarQube") {
                    sh 'sonar-scanner'
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