pipeline {
    agent any

    tools {
        jdk 'Jdk'
    maven 'Maven'
}
    
    environment {
        IMAGE_NAME = "kunwarsetia/timetracker:latest"
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

        stage('Debug Docker Path') {
            steps {
                sh 'echo $PATH'
                sh 'ls /opt/homebrew/bin'
               }
            }

        stage('Build Docker Image') {
            steps {
                sh '''
                export PATH=/opt/homebrew/bin:$PATH
                docker build -t $IMAGE_NAME .
                '''
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                    export PATH=/opt/homebrew/bin:$PATH
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
