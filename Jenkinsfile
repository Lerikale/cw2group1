pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDS = credentials('docker')   // DockerHub credentials in Jenkins
        IMAGE_NAME = "group1cw2/cw2-server"
        IMAGE_TAG = "1.0"
        MINIKUBE_SSH_CRED = "minikube-ssh"        // SSH credentials ID in Jenkins
        MINIKUBE_USER = "ubuntu"                // Replace with Minikube SSH username
        MINIKUBE_IP = "54.152.136.102"          // Replace with Minikube server IP
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Lerikale/cw2group1.git'
                script {
                    env.TAG = env.GIT_COMMIT.take(7)
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t $IMAGE_NAME:$env.TAG ."
                }
            }
        }

        stage('Test Container') {
            steps {
                script {
                    
                    sh "docker run -d --name ${env.TAG} -p 8081:8081 $IMAGE_NAME:$env.TAG"
                    sh "sleep 5"
                    sh "docker exec ${env.TAG} node -v"
                    sh "docker rm -f ${env.TAG}"
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    sh "echo $DOCKERHUB_CREDS_PSW | docker login -u $DOCKERHUB_CREDS_USR --password-stdin"
                    sh "docker push $IMAGE_NAME:$env.TAG"
                }
            }
        }

        stage('Deploy to Kubernetes (Minikube via SSH)') {
            steps {
                script {
                    sshagent([MINIKUBE_SSH_CRED]) {
                        sh """
                        ssh -o StrictHostKeyChecking=no $MINIKUBE_USER@$MINIKUBE_IP \\
                        'kubectl set image deployment/cw2-server-deployment cw2-server=$IMAGE_NAME:$env.TAG --record'
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs.'
        }
    }
}
