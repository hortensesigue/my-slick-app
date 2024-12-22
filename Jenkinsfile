pipeline {
    agent any
    environment {
        DOCKER_REPOSITORY = 'hortensehouendji/slick-test-app'
        DOCKER_CREDENTIALS = credentials('DockerHubcreds')
    }

    stages {
        stage('Source') {
            steps {
                echo 'retrieving the code from github'
                git branch: 'main', credentialsId: 'GithubCreds', url: 'https://github.com/hortensesigue/my-slick-app.git'
                
                // list the containt of the repo
                sh 'ls -l'
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building the container image'
                // building our image
                sh 'docker build -t $DOCKER_REPOSITORY:v$BUILD_NUMBER .'
            }
        }
        
        stage('Test') {
            steps {
                echo 'creating a test container'
                sh 'docker run --name "slick-test-app-container-v$BUILD_NUMBER" -t -d -p 80:80 $DOCKER_REPOSITORY:v$BUILD_NUMBER'
            }
        }
        
        stage('Manual Approval') {
            steps {
                echo 'waiting for manual approval'
                input 'Please, a revision is needed'
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'loging into dockerhub'
                sh 'docker login -u$DOCKER_CREDENTIALS_USR -p$DOCKER_CREDENTIALS_PSW'
                
                sh 'echo dockerhub login success'
                
                sh 'echo deploy to dockerhub'
                sh 'docker push $DOCKER_REPOSITORY:v$BUILD_NUMBER'
                
                sh 'echo the image of the following container was successfully deployed on github: $DOCKER_REPOSITORY:v$BUILD_NUMBER'
            }
        }

        stage('Deploy to k8') {
            steps {
                echo 'test connectivity to kubernetes cluster'
                sh '/var/lib/jenkins/bin/kubectl kubectl get nodes'
            }
        }
    }
    
    post { 
        // cleaning up...
        always { 
            echo 'Remove container'
            sh 'docker stop "slick-test-app-container-v$BUILD_NUMBER"'
            sh 'docker rm "slick-test-app-container-v$BUILD_NUMBER"'
            //sh 'docker stop "slick-test-app-container-v22"'
            //sh 'docker rm "slick-test-app-container-v22"'
            sh 'docker ps -l'
            sh 'docker logout'
        }
    }
}
