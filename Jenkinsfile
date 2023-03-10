pipeline {
   agent any
  
   environment {
       DOCKER_HUB_REPO = "gahoo82/flask-hello-world"
       CONTAINER_NAME = "flask-hello-world"
       DOCKERHUB_CREDENTIALS=credentials('dockerhub-credentials')
   }
  
   stages {
       /* We do not need a stage for checkout here since it is done by default when using the "Pipeline script from SCM" option. */


       stage('Build') {
           steps {
               echo 'Building..'
               sh 'docker image build -t $DOCKER_HUB_REPO:latest .'
           }
       }
       stage('Test') {
           steps {
               echo 'Testing..'
               sh 'docker stop $CONTAINER_NAME || true'
               sh 'docker rm $CONTAINER_NAME || true'
               sh 'docker run --name $CONTAINER_NAME $DOCKER_HUB_REPO /bin/bash -c "pytest test.py && flake8"'
           }
       }
        stage('Push') {
           steps {
               echo 'Pushing image..'
               sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
               sh 'docker push $DOCKER_HUB_REPO:latest'
           }
       }
        stage('Deploy') {
           steps {
               echo 'Deploying....'
               sh 'scp -v -r -o StrictHostKeyChecking=no deployment.yaml service.yaml ubuntu@3.65.39.144:/home/ubuntu'
               sh 'ssh ubuntu@3.65.39.144 kubectl apply -f /home/ubuntu/deployment.yaml'
               sh 'ssh ubuntu@3.65.39.144 kubectl apply -f /home/ubuntu/service.yaml'
           }
       }
   }
}