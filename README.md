<img src="/images/digram.png" alt="Permissions" />

```diff 

skills:

    Working in AWS
    Using Jenkins to implement Continuous Integration and Continuous Deployment
    Building pipelines
    Working with CloudFormation to deploy clusters
    Building Kubernetes clusters
    Building Docker containers in pipelines

scenario:
    create AWS EC2 instance and install Jenkins, docker on it
    make IAM user with admin privilege and use it for the jenkins-aws connection
    install dockerhub and AWS pipeline plugins on Jenkins and add their credentials
    create aws cluster by running create-aws-eks-cluster.sh
    run jenkinsfile which will build docker image and upload it to dockerhub and then create 2 stages blue and green deployment and run the blue deployment using blue-service which is a kubernetes loadbalancer pointing to the blue deployment using code selector=blue then check if the green environment is ready for being used if yes jenkins will run green-service which will point loadbalancer to the green deployment using code `selector=green'

```

### Project description

- environment 
```diff 
 environment {
    registry = "hossamalsankary/nodejs_app" # app name
    registryCredential = 'docker_credentials' # my docker hup credentials 
    ANSIBLE_PRIVATE_KEY = credentials('secritfile')  # for ssh connection secret.pem file 
  }
```
- Stage(1) install all required dependencies and clear the Jenkins environment
```diff 

  stage("install dependencies") {

      steps {
        sh 'npm install'
      }
      post {
        always {
          sh 'bash ./clearDockerImages.sh' # you can find this bashscript here[link]("/clearDockerImages.sh")
        }

      }

    }

```
<img src="/images/1.png" alt="Permissions" />


- Stage(2) run command (npm test)  to test the code before build it
```diff 
        stage("Test") {

            steps {

              sh 'npm run  test:unit'

            }

          }
```
<img src="/images/2.png" alt="Permissions" />

- Stage(3) run command (npm build)
```diff
        stage("Build") {

            steps {

              sh 'npm run build'
            }

          }
           

```
<img src="/images/3.png" alt="Permissions" />

- Stage (4) build our app docker image
```diff 
    stage("Build Docker Image") {
      steps {

        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER" #  build the app  in node.js container you can find the docker file here []()
        }
      }
      post {

        failure {
          sh '  docker system prune --volumes -a -f ' # clear every thing 
        }
      }
    }
```
<img src="/images/4.png" alt="Permissions" />

- Stage (5) push the docker image to the docker hub account with a different tag number
``` diff 
stage("push image to docker hup") {
      steps {
        script {
          docker.withRegistry('', registryCredential) { # this very importaint to login with registryCredential
            dockerImage.push() # now we can push the image
          }
        }
      }
    }
```
<img src="/images/5.png" alt="Permissions" />

- Stage (6) create kubecontext file
```diff 
stage('create kubecontext file') {
      steps {
        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {

          sh 'aws eks update-kubeconfig --region us-east-2 --name jenkins-cluster '
          sh 'kubectl get nodes'

        }
      }

    }

```
<img src="/images/6.png" alt="Permissions" />

- Stage (7) Make sure  that we have geen-namespace and blue-ns 
```diff 
   stage("Make sure  that we have geen-namespace and blue-ns ") {
      steps {
        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {

          // check for namespaces blue and green
          sh 'bash ./bash-scripts/cheackForNameSpaces.sh'

        }
      }
    }
```
-  Stage (8) Deploy blue deployment if not exsit 
```diff 
       stage("Deploy blue deployment if not exsit ") {
      steps {

        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {

          // we do not want to destroy prodaction app but if that`s the first pipline deploy if anyway
          sh 'bash  ./bash-scripts/check-if-blue-is-exist-ordeploy-it-if-not.sh'

        }
      }
    }
```
<img src="/images/8.png" alt="Permissions" />

- Stage(10) "Deploy Green deployment if not exsit 
```diff 
  stage("Deploy Green deployment if not exsit ") {
      steps {

        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {

          // update the greep app with new docker image
          // deploymet
          sh '  kubectl  apply  -f ./k8s/green-deployment.yaml '
          // service
          sh '  kubectl  apply  -f ./k8s/green-service.yaml '

        }
      }
    }
```

<img src="/images/9.png" alt="Permissions" />

- stage(11) Smoke Test
```diff 
 stage("Smoke Test") {
      steps {
        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          sh ' kubectl get service,pod --namespace=green-deployment --all-namespaces=true'
          sh 'bash ./bash-scripts/smokeTest.sh'

        }
      }
    }
```

<img src="/images/10.png" alt="Permissions" />

## stage(12) update blue app with new docker Image
```diff
stage("update blue app with new docker Image ") {

      steps {

        sh ""
        "
        sed - i 's|hossamalsankary/nodejs_app:49|$registry:$BUILD_NUMBER|g'. / k8s / green - deployment.yaml

        ""
        "

        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          // update the blue app with new docker image
          // deploymet
          sh '  kubectl  apply  -f ./k8s/blue-deployment.yaml '
          // service
          sh '  kubectl  apply  -f ./k8s/blue-service.yaml '

        }

      }
    }

 ```
 <img src="/images/11.png" alt="Permissions" />
## Destroy Green version
 ```diff 
 
   stage('Destroy Green version') {
      steps {

        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          // update the blue app with new docker image
          sh 'bash ./bash-scripts/clear-green-deployment.sh'

        }

      }
    }

  }
 ```

 ```
 <img src="/images/12.png" alt="Permissions" />
 
 <img src="/images/13.png" alt="Permissions" />
 <img src="/images/14.png" alt="Permissions" />
 <img src="/images/15.png" alt="Permissions" />
 <img src="/images/16.png" alt="Permissions" />
 <img src="/images/17.png" alt="Permissions" />
