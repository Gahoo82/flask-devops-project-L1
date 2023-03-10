# flask-devops-project-L1
Building and Deploying a Simple Flask applications using Jenkins and Kubernetes

In this project, we are going to build a simple [CI/CD](https://www.atlassian.com/continuous-delivery/principles/continuous-integration-vs-delivery-vs-deployment) pipeline from scratch using tools like Flask, Docker, Git, Github, Jenkins and Kubernetes.
 
## Prerequisites
 
* Python
* Flask
* Docker
* Git and Github
* Jenkins
* Kubernetes
* EC2-instances with Linux
 
## Steps in the CI/CD pipeline
1. Create a "Hello world" Flask application
2. Write basic test cases
3. Dockerise the application
4. Test the code locally by building docker image and running it
5. Create a github repository and push code to it
6. Start a Jenkins server on Amazon EC2 instance
7. Write a Jenkins pipeline to build, test and push the docker image to Dockerhub.
8. Set up Kubernetes on Amazon EC2 instance using [Minikube](https://minikube.sigs.k8s.io/docs/start/)
9. Create a Kubernetes deployment and service for the application.
10. Use Jenkins to deploy the application on Kubernetes
 
## Project structure
 
* app.py - Flask application which will print "Hello world" when you run it
* test.py - Test cases for the application
* requirements.txt - Contains dependencies for the project
* Dockerfile - Contains commands to build and run the docker image
* Jenkinsfile - Contains the pipeline script which will help in building, testing and deploying the application
* deployment.yaml - [Kubernetes deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) file for the application
* service.yaml - [Kubernetes service](https://kubernetes.io/docs/concepts/services-networking/service/) file for the application


### Clone my Github repository to local host.

 ```powershell
git clone https://github.com/Gahoo82/flask-devops-project-L1.git
 ```
 ![git-clone-rep](images/1-git-clone-rep.png)
 
 ### Set up virtual Python environment

 Setting up a [virtual Python environment](https://docs.python.org/3/library/venv.html) will help in testing the code locally and also collecting all the dependencies.
 
```powershell
> py -m venv venv # Create the virtual env named venv
> venv/Scripts/activate # Activate the virtual env
```
 
## Create a Flask application
 
Install the flask module.
 
```powershell
> pip install flask
```
Open cloned "flask-devops-project-L1" repository in Visual Studio Code.
Create a new file named "app.py" and add the below code.
 
```python
from flask import Flask
import os
 
app = Flask(__name__)
 
 @app.route("/")
def hello():
   return "Hello world!!!"
  
if __name__ == "__main__":
   port = int(os.environ.get("PORT", 5000))
   app.run(debug=True, host='0.0.0.0', port=port)
```
 
This code when run will start a web server on port number 5000. 
 
```powershell
> python app.py
```

![py-venv-flask](images/2-py-venv-flask-install.png)

## Write test cases using pytest
 
Install [pytest](https://docs.pytest.org/en/7.1.x/) module. We will use pytest for testing.
 
```powershell
> pip install pytest
```

![install-pytest](images/3-pip-install-pytest.png)

Create a new file named "test.py" and add a basic test case.
 
```python
from app import app
 
def test_hello():
   response = app.test_client().get('/')
   assert response.status_code == 200
   assert response.data == b'Hello world!!!'
```
 
Run the test file using pytest.
 
```powershell
> pytest test.py
```

![pytest test.py](images/4-pytest-test-py.png)

## Run code quality tests using flake
 
It's always recommended to write quality code with proper coding standards, proper code formatting and code with no syntax errors.
 
[Flake8](https://flake8.pycqa.org/en/latest/) can be used to check the quality of the code in Python.
 
Install the flake8 module.
 
```powershell
> pip install flake8
```
![install-flake](images/5-install-flake8.png)
 
Run flake8 command.
 
```powershell
> flake8 --exclude venv # Ignore files in venv for quality check
```
 
If you do not see any output, it means that everything is alright with code quality.
 
Try add extra spaces in the app.py and then run flake8 command again. You should see the errors.

Remove extra spaces and we will not see the errors now.

![bug-fixes-flake8](images/6-flake8-bugs-fixes.png)


## Dockerise the application
 
Install docker on local system. Following [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)
 
Create a file named "Dockerfile" and add the below code.
 
```dockerfile
FROM python:3.10
LABEL maintainer="chernenko.kostua@gmail.com"
COPY app.py test.py /app/
WORKDIR /app
RUN pip install flask pytest flake8 # This downloads all the dependencies
CMD ["python", "app.py"]
```
 
Build the docker image.
 
```powershell
> docker build -t flask-hello-world .
```
 
Run the application using docker image.
 
```powershell
> docker run -it -p 5000:5000 flask-hello-world
```

 ![docker-build-run](images/7-docker-build-run.png)

Run test case
 
```powershell
> docker run -it flask-hello-world pytest test.py
```
 
Run flake8 tests
 
```powershell
> docker run -it flask-hello-world flake8
```
 
We can verify if the application is running by opening the page in the browser.
 
Push the image to dockerhub. We will need an account on docker hub for this.
 
```powershell
> docker login # Login to docker hub
> docker tag flask-hello-world gahoo82/flask-hello-world
docker push gahoo82/flask-hello-world
```

![docker-test-flake8-tag-push](images/8-docker-test-flake8-tag-push.png)
 
## Push the code to github


## Install Jenkins
 
Next we will launch EC2 instance on AWS with Ubuntu 22.04 will install Jenkins on that instance. 
[https://phoenixnap.com/kb/install-jenkins-ubuntu](https://phoenixnap.com/kb/install-jenkins-ubuntu).

 ![create-EC2-Ubuntu](images/9-create-EC2-Ubuntu.png)

Create Key pair and Security Group

![key-pair](images/10-key-pair.png)


![security-group](images/11-security-group.png)

Download private key to local host and connect to EC2 instance with Powershell via SSH.

![ssh-aws](images/12-ssh.png)

![ssh-powershell](images/13-ssh-powershell.png)

 
Run the following commands on the server.
 
```powershell
# Install jenkins
 
> curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
/usr/share/keyrings/jenkins-keyring.asc > /dev/null
 
> echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null
 
> sudo apt-get update
> sudo apt install openjdk-11-jre
> sudo apt-get install jenkins
 
# Install docker and add jenkins user to docker group
# Installing docker is important as we will be using jenkins to run docker commands to build and run the application.
> sudo apt install docker.io
> sudo usermod -aG docker jenkins
> sudo service jenkins restart
```
 
Open browser and visit [http://18.184.53.45:8080/](http://18.184.53.45:8080/)] - public address of the EC2 instance.
 
![jenkins-homepage](images/14-jenkins-homepage.png)
 
Copy the admin password from the path provided on the jenkins homepage and enter it. Click on "Install suggested plugins". It will take some time to install the plugins.
 
![install-plugins](images/15-jenkins-plugins.png)
 
Create a new user.
 
![create-jenkins-user](images/16-create-jenkins-user.png)
 
You should now see the jenkins url. Click next and you should see the "Welcome to jenkins" page now.
 
## Create a Jenkins pipeline
 
We will now create a Jenkins pipeline which will help in building, testing and deploying the application.
 
Click on "?????????????? Item" on the top left corner of the homepage.
 
![new-item-jenkins](images/17-jenkins-new-item.png)
 
Enter a name, select "Pipeline" and click next.
 
![select-jenkins-item](images/18-jenkins-pipeline-create.png)
 
Now we need to write a [pipeline script](https://www.jenkins.io/doc/book/pipeline/syntax/) in Groovy for building, testing and deploying code.
 
![jenkins-script](images/19-pipeline-script.png)
 
Enter the below code in the pipeline section and click on "Save".
 
```
pipeline {
   agent any
  
   environment {
       DOCKER_HUB_REPO = "gahoo82/flask-hello-world"
       CONTAINER_NAME = "flask-hello-world"
 
   }
  
   stages {
       stage('Checkout') {
           steps {
               checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Gahoo82/flask-devops-project-L1.git']]])
           }
       }
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
       stage('Deploy') {
           steps {
               echo 'Deploying....'
               sh 'docker stop $CONTAINER_NAME || true'
               sh 'docker rm $CONTAINER_NAME || true'
               sh 'docker run -d -p 5000:5000 --name $CONTAINER_NAME $DOCKER_HUB_REPO'
           }
       }
   }
}
```
 
Click on the "?????????????? ????????????" button at the left of the page.
 
The pipelines should start running now and you should be able to see the status of the build on the page.
 
![jenkins-building](images/20-jenkins-build-pipeline.png)
 
If the build is successful, we can visit [http://18.184.53.45:5000](http://18.54.53.45:5000) and we should see "Hello world" on the browser. 

![hello-world-ec2](images/21-hello-world-onEC2.png)
 
## Pipeline script from SCM
 
We can also store the Jenkins pipeline code in our github repository and ask Jenkins to execute this file.
 
Go to the "flask-hello-world" pipeline page and click on "??????????????????".
 
Change definition from "Pipeline script" to "Pipeline script from SCM" and fill details on SCM and github url. Save the pipeline.
 
![pipeline-from-scm](images/22-pipeline-from-scm.png)
 
Now, create a new file named "Jenkinsfile" in our local code repository and add the below pipeline code.
 
```
pipeline {
   agent any
  
   environment {
       DOCKER_HUB_REPO = "gahoo82/flask-hello-world"
       CONTAINER_NAME = "flask-hello-world"
 
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
       stage('Deploy') {
           steps {
               echo 'Deploying....'
               sh 'docker stop $CONTAINER_NAME || true'
               sh 'docker rm $CONTAINER_NAME || true'
               sh 'docker run -d -p 5000:5000 --name $CONTAINER_NAME $DOCKER_HUB_REPO'
           }
       }
   }
}
```
 
Push the code to github.
 
 
Go to "flask-hello-world" pipeline page and click on "Build Now"
 
![jenkins-build-scm](images/23-pipeline-with-git.png)


## Install Kubernetes

In this case, I'll be installing Kubernetes on new EC2-instance.

```powershell
# https://minikube.sigs.k8s.io/docs/start/
 
# Install docker for managing containers
sudo apt-get install docker.io
 
# Install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
 
# Add the current USER to docker group
sudo usermod -aG docker $USER && newgrp docker
 
# Start minikube cluster
minikube start
 
# Add an alias for kubectl command
alias kubectl="minikube kubectl --"
```

Create a new file named "deployment.yaml" in /home/ubuntu/ and add the below code.
 
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
 name: flask-hello-deployment # name of the deployment
 
spec:
 template: # pod defintion
   metadata:
     name: flask-hello # name of the pod
     labels:
       app: flask-hello
       tier: frontend
   spec:
     containers:
       - name: flask-hello
         image: gahoo82/flask-hello-world:latest
 replicas: 3
 selector: # Mandatory, Select the pods which needs to be in the replicaset
   matchLabels:
     app: flask-hello
     tier: frontend
```
 
Test the deployment manually by running the following command:
 
```powershell
$ kubectl apply -f deployment.yaml
deployment.apps/flask-hello-deployment created

$ kubectl get deployments flask-hello-deployment
NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
flask-hello-deployment   3/3     3            3           45s
```
 
Create a new file named "service.yaml" and add the following code
 
```yaml
apiVersion: v1
kind: Service
metadata:
 name: flask-hello-service-nodeport # name of the service
 
spec:
 type: NodePort # Used for accessing a port externally
 ports:
   - port: 5000 # Service port
     targetPort: 5000 # Pod port, default: same as port
     nodePort: 30008 # Node port which can be used externally, default: auto-assign any free port
 selector: # Which pods to expose externally ?
   app: flask-hello
   tier: frontend
```
 
Test the service manually by running below commands.
 
```bash
$ kubectl apply -f service.yaml
service/flask-hello-service-nodeport created

$ kubectl get service flask-hello-service-nodeport
NAME                           TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
flask-hello-service-nodeport   NodePort   10.111.161.128   <none>      5000:30008/TCP   36s
```
 
Run below command to access the application on the browser.
 
```bash
minikube service flask-hello-service-nodeport
```
Finally, push the updated code to github

## Deploy using jenkins on kubernetes

First, I'll add docker hub credentials in jenkins. This is needed as I have to first push the docker image before deploying on kubernetes.

![docker-cred-for-jenkins](images/24-docker-cred-for-jenkins.png)

Now modify Jenkinsfile in the project to push the image and then deploy the application on kubernetes.

```groovy
pipeline {
   agent any
  
   environment {
       DOCKER_HUB_REPO = "gahoo82/flask-hello-world"
       CONTAINER_NAME = "flask-hello-world"
       DOCKERHUB_CREDENTIALS=credentials('dockerhub-credentials')
   }
  
   stages {
       /* We do not need a stage for checkout here since it is done by default when using "Pipeline script from SCM" option. */
      
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
               sh 'minikube kubectl -- apply -f deployment.yaml'
               sh 'minikube kubectl -- apply -f service.yaml'
           }
       }
   }
}
```
 
Commit the changes to github.
  
Go to "flask-hello-world" pipeline page and click on "Build Now"

Create a ssh key pair on jenkins server.
 
```powershell
$ cd ~/.ssh # We are on jenkins server
$ ssh-keygen -t rsa # select the default options
$ cat id_rsa.pub # Copy the public key
```
 
Add the public key we created to authorized_keys on kubernetes server.
 
```powershell
$ cd ~/.ssh # We are on kubernetes server
$ echo "<public key>" >> authorized_keys
```
 
Modify the 'Deploy' section of Jenkinsfile. 
 
```groovy
stage('Deploy') {
           steps {
               echo 'Deploying....'
               sh 'scp -v -r -o StrictHostKeyChecking=no deployment.yaml service.yaml ubuntu@3.65.39.144:/home/ubuntu'
               sh 'ssh ubuntu@3.65.39.144 kubectl apply -f /home/ubuntu/deployment.yaml'
               sh 'ssh ubuntu@3.65.39.144 kubectl apply -f /home/ubuntu/service.yaml'
           }
       }
```

Change number of replicas in deployment.yaml

![5-replicas](images/26-change-replicas.png)

Commit the code. Build the pipeline again on Jenkins server.

![final-pipeline-build](images/25-final-pipeline-build.png)

And now we can see 5 pods running.

![vinikube-pods](images/27-minikube-server-output.png)





