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
* Linux machine
 
## Steps in the CI/CD pipeline
1. Create a "Hello world" Flask application
2. Write basic test cases
3. Dockerise the application
4. Test the code locally by building docker image and running it
5. Create a github repository and push code to it
6. Start a Jenkins server on a host
7. Write a Jenkins pipeline to build, test and push the docker image to Dockerhub.
8. Set up Kubernetes on a host using [Minikube](https://minikube.sigs.k8s.io/docs/start/)
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
 
 <p align="center">
  <img src="https://github.com/Gahoo82/flask-devops-project-L1/blob/main/images/1-git-clone-rep.png">
 </p>

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
