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
  }
}
