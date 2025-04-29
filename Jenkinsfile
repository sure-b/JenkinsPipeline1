pipeline {
    agent any
    
    tools {
        nodejs 'Node18'   
    }
    
    environment {
        DOCKER_BUILDKIT = '1'
        APP_NAME = 'react-app'
        DOCKER_IMAGE = "${APP_NAME}:${BUILD_NUMBER}"
        PORT = '80'
    }
    
    stages {
        stage('Verify Prerequisites') {
            steps {
                script {
                    // Check Docker installation and permissions
                    sh '''
                        # Check Docker installation
                        if ! command -v docker &> /dev/null; then
                            echo "Docker is not installed. Please install Docker first."
                            exit 1
                        fi
                        
                        # Ensure Docker daemon is running
                        if ! docker info >/dev/null 2>&1; then
                            echo "Docker daemon is not running. Please start Docker service."
                            exit 1
                        fi
                        
                        # Display versions for logging
                        echo "Docker version:"
                        docker --version
                        
                        echo "Node version:"
                        node --version
                        
                        echo "NPM version:"
                        npm --version
                    '''
                }
            }
        }
        
        stage('Install Dependencies') {
            steps {
                script {
                    sh '''
                        npm cache clean --force
                        npm install --legacy-peer-deps --force
                        npm install ajv@8.12.0 ajv-keywords@5.1.0 --force
                    '''
                }
            }
        }
        
        stage('Build React App') {
            steps {
                script {
                    sh '''
                        export CI=false
                        npm run build
                    '''
                }
            }
        }
        
        stage('Docker Build & Deploy') {
            steps {
                script {
                    sh """
                        # Build new Docker image
                        docker build -t ${DOCKER_IMAGE} .
                        
                        # Stop and remove existing container
                        docker stop ${APP_NAME} || true
                        docker rm ${APP_NAME} || true
                        
                        # Run new container
                        docker run -d -p ${PORT}:80 --name ${APP_NAME} ${DOCKER_IMAGE}
                        
                        # Verify container is running
                        sleep 5
                        if ! docker ps | grep ${APP_NAME}; then
                            echo "Container failed to start"
                            docker logs ${APP_NAME}
                            exit 1
                        fi
                    """
                }
            }
        }
    }
    
    post {
        always {
            // Clean workspace
            cleanWs()
            
            // Print container status
            sh """
                echo "Container status:"
                docker ps -a | grep ${APP_NAME} || true
            """
        }
        success {
            script {
                sh """
                    echo "Deployment successful!"
                    echo "Application is accessible at http://localhost:${PORT}"
                    docker ps | grep ${APP_NAME}
                """
            }
        }
        failure {
            script {
                sh """
                    echo "Deployment failed!"
                    echo "Container logs:"
                    docker logs ${APP_NAME} || true
                """
            }
        }
    }
}