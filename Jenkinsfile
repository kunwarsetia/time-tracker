pipeline {
    agent any

    tools {
        jdk 'Jdk'
    maven 'Maven'
        docker 'docker'
}
    
    environment {
        IMAGE_NAME = "your-dockerhub-username/timetracker:latest"
    }

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/kunwarsetia/time-tracker.git'
            }
        }

        stage('Build') {
            steps {
                dir('web') {
                    sh 'mvn clean install -DskipTests'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                export PATH=/opt/homebrew/bin/docker:$PATH
                docker build -t $IMAGE_NAME .
                '''
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                    export PATH=/opt/homebrew/bin/docker:$PATH
                    docker login -u $USER -p $PASS
                    docker push $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
            }
        }
    }
}
