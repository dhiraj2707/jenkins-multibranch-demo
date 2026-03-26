pipeline {
    agent any

    environment {
        // DockerHub username
        DOCKERHUB_USER = "bhau2707"
        // Docker image name
        IMAGE_NAME = "${DOCKERHUB_USER}/jenkins-demo"
        // Tag based on branch and build number
        TAG = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                // Checkout source code of the current branch
                checkout scm
                echo "Checked out branch: ${env.BRANCH_NAME}"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image ${IMAGE_NAME}:${TAG}"
                sh "docker build -t ${IMAGE_NAME}:${TAG} ."
            }
        }

        stage('Push to DockerHub') {
            steps {
                // Use Jenkins stored credentials for DockerHub
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds', // Replace with your Jenkins credentials ID
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
                echo "Deploying Docker container ${env.BRANCH_NAME}"
                sh """
                # Remove old container if exists
                docker rm -f ${env.BRANCH_NAME} || true
                # Run new container
                docker run -d --name ${env.BRANCH_NAME} -p 8080:80 ${IMAGE_NAME}:${TAG}
                """
            }
        }
    }

    post {
        always {
            echo "Pipeline finished for ${env.BRANCH_NAME}"
        }
        success {
            echo "Build and deployment successful!"
        }
        failure {
            echo "Pipeline failed. Check logs for errors."
        }
    }
}
