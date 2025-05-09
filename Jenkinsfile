pipeline {
  agent any

  environment {
    SONARQUBE_SERVER = 'http://sonarqube:9000'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install dependencies') {
      steps {
        sh 'pip install -r app/requirements.txt'
      }
    }

    stage('Run Tests') {
      steps {
        sh 'pytest app/tests'
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv('SonarQube') {
          sh 'sonar-scanner'
        }
      }
    }

    stage('Quality Gate') {
      steps {
        timeout(time: 2, unit: 'MINUTES') {
          script {
            def qg = waitForQualityGate()
            if (qg.status != 'OK') {
              error "Quality Gate falhou: ${qg.status}"
            }
          }
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t esteiradevsecops ./app'
      }
    }

    stage('Deploy') {
      steps {
        sh 'docker-compose up -d --build'
      }
    }
  }
}
