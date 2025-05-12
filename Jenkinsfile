pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE_NAME = 'sure89/new-react-app'  // Docker image name
        DOCKER_HUB_CREDENTIALS = 'DockerHub-Cred'  // Jenkins credentials for Docker Hub
        DEPLOY_SERVER = 'localhost'                 // Docker Desktop is running on the same machine as Jenkins
        DEPLOY_USER = 'your_ssh_user'              // SSH user for remote deployment (if necessary)
        DEPLOY_KEY = 'ssh-key-credentials'         // SSH credentials ID for Jenkins
    }
    
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image from the 'New-react-app' directory
                    dir('my-react-app') {
                        dockerImage = docker.build("${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}")
                    }
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    // Log in to Docker Hub and push the image
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_HUB_CREDENTIALS) {
                        dockerImage.push()  // Push the built image to Docker Hub
                    }
                }
            }
        }

        stage('Deploy to Docker Desktop') {
            steps {
                script {
                    // Log in to Docker Desktop and deploy the image
                    // If Docker Desktop is on the same machine as Jenkins, we can use local Docker CLI commands
                    // If it's remote, use SSH to connect to the Docker Desktop host

                    if (DEPLOY_SERVER == 'localhost') {
                        // If Docker Desktop is on the same machine as Jenkins
                        echo "Deploying Docker image to Docker Desktop locally..."

                        // Pull the image from Docker Hub to Docker Desktop
                        sh "docker pull ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"

                        // Run the container (expose port 80)
                        sh "docker run -d -p 80:80 --name new-react-app ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"
                    } else {
                        // Use SSH to deploy to a remote Docker Desktop machine (if necessary)
                        sshagent(credentials: [DEPLOY_KEY]) {
                            sh """
                                echo "Deploying to ${DEPLOY_SERVER}..."
                                ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_SERVER} '
                                    docker pull ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER} &&
                                    docker run -d -p 80:80 --name new-react-app ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}
                                '
                            """
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Docker image successfully built, pushed to Docker Hub, and deployed to Docker Desktop!"
        }
        failure {
            echo "The pipeline failed. Please check the logs for errors."
        }
    }
}
