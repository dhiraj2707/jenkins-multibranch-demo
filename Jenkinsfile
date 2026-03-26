pipeline {
    agent any

    environment {
        IMAGE_NAME = "your-dockerhub-username/jenkins-demo"
        TAG = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
                echo "Branch: ${env.BRANCH_NAME}"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${TAG} ."
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh """
                    echo $PASS | docker login -u $USER --password-stdin
                    docker push ${IMAGE_NAME}:${TAG}
                    """
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh """
                docker rm -f ${env.BRANCH_NAME} || true
                docker run -d --name ${env.BRANCH_NAME} ${IMAGE_NAME}:${TAG}
                """
            }
        }
    }
}
