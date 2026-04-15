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
        stage('Check WAR') {
             steps {
                sh 'ls web/target'
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
                withCredentials([usernamePassword(credentialsId: 'ebc80b7f-d175-4f74-8dd7-339a5b651c7a', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                    export PATH=/opt/homebrew/bin:$PATH
                    echo "Logging into DockerHub"
                    docker login -u $USER -p $PASS
                     echo "pushing images in DockerHub"
                    docker push $IMAGE_NAME
                    ls
                    '''
                }
            }
        }
        stage('Debug Next Stage') {
    steps {
        echo 'Reached next stage'
    }
}

        stage('Deploy to Kubernetes') {
            steps {
                sh 'export PATH=/opt/homebrew/bin/:$PATH'
                sh '/opt/homebrew/bin/kubectl apply -f deployment.yaml'
                sh '/opt/homebrew/bin/kubectl apply -f deployment.yaml'
            }
        }
    }
}
