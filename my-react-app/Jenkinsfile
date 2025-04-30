    pipeline {
        agent any
        
        stages {
            stage('Build Image') {
                steps {
                    script {
                        dockerImage = docker.build("sure89/my-react-app:${env.BUILD_NUMBER}")
                    }
                }
            }
            stage('Push Image') {
                steps {
                    script {
                        docker.withRegistry('https://index.docker.io/v1/', 'DockerHub-Cred') {
                            dockerImage.push()
                        }
                    }
                }
            }
        }
    }
