def serverIP = 'soe data'
pipeline {
  agent any
  

  environment {
    registry = "hossamalsankary/nodejs_app"
    registryCredential = 'docker_credentials'
    ANSIBLE_PRIVATE_KEY = credentials('secritfile')
  }

  stages {
    // stage("install dependencies") {

    //   steps {
      
    //     sh 'npm install'
    //   }
    //   post {
    //     always {
    //       sh 'bash ./clearDockerImages.sh'
    //     }

    //   }

    // }

    // stage(" Build and Test"){
    //   parallel {
    //     stage("Test") {

    //         steps {

    //           sh 'npm run  test:unit'

    //         }

    //       }
    //     stage("Build") {

    //         steps {
    //            sh 'npm run build'
    //         }

    //       }
    //   }
    // }
  

 
    // stage("Build Docker Image") {
    //   steps {

    //     script {
    //       dockerImage = docker.build registry + ":$BUILD_NUMBER"
    //     }
    //   }
    //   post {

    //     failure {
    //       sh '  docker system prune --volumes -a -f '
    //     }
    //   }
    // }

    // stage("push image to docker hup") {
    //   steps {
    //     script {
    //       docker.withRegistry('', registryCredential) {
    //         dockerImage.push()
    //       }
    //     }
    //   }
    // }

    // stage("Test Docker Image In Dev Server ") {
    //   steps {
    //     sh ' docker run --name test_$BUILD_NUMBER -d -p 5000:8080 $registry:$BUILD_NUMBER '
    //     sh 'sleep 2'
    //     sh 'curl localhost:5000'
    //   }

    // }

    

      stage('create kubecontext file') {
      steps {
       withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {

               sh 'aws eks update-kubeconfig --region us-east-2 --name jenkins-cluster '
               sh 'kubectl get nodes'
            
         }
        }

      }

      stage("Make sure  that we have geen-namespace and blue-ns "){
          steps{
       withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {

            // check for namespaces blue and green
            sh 'bash ./bash-scripts/cheackForNameSpaces.sh'
            
         }
      }
      }

    stage("Deploy blue deployment if not exsit "){
          steps{

        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {

              // we do not want to destroy prodaction app but if that`s the first pipline deploy if anyway
              sh 'bash  ./bash-scripts/check-if-blue-is-exist-ordeploy-it-if-not.sh'

              
          }
          }
        }

       stage("Deploy Green deployment if not exsit "){
         steps{

       withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {

            // update the greep app with new docker image
            // deploymet
           sh '  kubectl  apply  -f ./k8s/green-deployment.yaml '
            // service
           sh '  kubectl  apply  -f ./k8s/green-service.yaml '  

            
         }
         }
      }

      stage("Smoke Test"){
        steps{
           withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {

          sh '''
         export blueIP=$(kubectl get services --namespace=blue-deployment  blueservice --output jsonpath='{.status.loadBalancer.ingress[0]}'| tr -d '"' | tr -d '}' | cut -d ':' -f 2 )
         export greenIP=$(kubectl get services --namespace=green-deployment  greenservice --output jsonpath='{.status.loadBalancer.ingress[0]}'| tr -d '"' | tr -d '}' | cut -d ':' -f 2 )

          '''
          sh 'curl $blueIP:8080'
          sh 'curl $greenIP:8080'

           }
        }
      }

  }
}
