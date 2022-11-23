def serverIP = 'soe data'
pipeline {
  agent any
  options {
    skipDefaultCheckout(true)
  }
  parameters {
    string(name: 'server_ip', defaultValue: '')
  }
  environment {
    registry = "hossamalsankary/nodejs_app"
    registryCredential = 'docker_credentials'
  }

  stages {
    stage("install dependencies") {

      steps {
        sh 'npm install'
      }
      post {
        always {
          sh 'bash ./clearDockerImages.sh'
        }

      }

    }

    stage("Test and Build"){
      parallel {
        stage("Test") {

            steps {

              sh 'npm run  test:unit'

            }

          }
        stage("Build") {

            steps {

              sh 'npm run build'
            }

          }
      }
    }
  

 
    stage("Build Docker Image") {
      steps {

        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
      post {

        failure {
          sh '  docker system prune --volumes -a -f '
        }
      }
    }

    stage("push image to docker hup") {
      steps {
        script {
          docker.withRegistry('', registryCredential) {
            dockerImage.push()
          }
        }
      }
    }

    stage("Test Docker Image In Dev Server ") {
      steps {
        sh ' docker run --name test_$BUILD_NUMBER -d -p 5000:8080 $registry:$BUILD_NUMBER '
        sh 'sleep 2'
        sh 'curl localhost:5000'
      }

    }
   
 
    // stage("Somok test in prod server") {
    //     when {
    //     branch 'master'
    //   }
    //   steps {
    //     echo "${serverIP}"
        
    //     sh  "curl ${serverIP} "
    //   }
    //   post {

    //     success {
    //       echo "====> Somok test successful ====>"
    //     }
    //     failure {
    //       echo "====++++only when failed++++===="
    //       withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {

    //         dir("terraform-aws-instance") {
    //          sh 'terraform destroy --auto-approve'

    //         }
    //       }
    //     }
    //   }
    // }

  }

  // post {
  //   always {
  //     cleanWs(cleanWhenNotBuilt: false,
  //       deleteDirs: true,
  //       disableDeferredWipeout: true,
  //       notFailBuild: true,
  //       patterns: [
  //         [pattern: '.gitignore', type: 'INCLUDE'],
  //         [pattern: '.propsfile', type: 'EXCLUDE']
  //       ])
  //   }
  //   success {
  //     echo "========A executed successfully========"
  //     sh 'bash ./clearDockerImages.sh'

  //   }
  //   failure {
          

  //        sh 'bash ./clearDockerImages.sh'
  //   }
  // }
}


// pipeline {
//   agent any
//   stages {
//     stage('Lint HTML') {
//       steps {
//         sh 'tidy -q -e *.html'
//       }
//     }

//     stage('build docker image') {
//       steps {
//         withCredentials(bindings: [[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]) {
//           sh '''
//               docker build -t sidiali/capstone_repo:capstone_app .
//              '''
//         }

//       }
//     }

//     stage('push docker image to dockerhub repository') {
//       steps {
//         withCredentials(bindings: [[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]) {
//           sh '''
//                docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
//                docker push sidiali/capstone_repo:capstone_app 
//                '''
//         }

//       }
//     }
    
//   stage('create kubecontext file') {
//       steps {
//         withAWS(region: 'us-east-2', credentials: 'MyCredentials') {
//           sh '''
//                       aws eks update-kubeconfig --name jenkinstest2
//                    '''
//         }

//       }
//     }

//     stage('Set current kubectl context') {
//       steps {
//         withAWS(region: 'us-east-2', credentials: 'MyCredentials') {
//           sh '''
//                       kubectl config use-context arn:aws:eks:us-east-2:128971627436:cluster/jenkinstest2
//                    '''
//         }

//       }
//     }

//     stage('create replication controller for blue app') {
//       steps {
//         withAWS(region: 'us-east-2', credentials: 'MyCredentials') {
//           sh '''
//                       kubectl apply -f ./blue-replication-controller.yaml
//                    '''
//         }

//       }
//     }

//     stage('create replication controller for green app') {
//       steps {
//         withAWS(region: 'us-east-2', credentials: 'MyCredentials') {
//           sh '''
//                       kubectl apply -f ./green-replication-controller.yaml
//                    '''
//         }

//       }
//     }

//     stage('create service for blue app and make loadbalancer point to it') {
//       steps {
//         withAWS(region: 'us-east-2', credentials: 'MyCredentials') {
//           sh '''
//                       kubectl apply -f ./blue-service.yaml
//                    '''
//         }

//       }
//     }

//     stage('Sanity check') {
//       steps {
//         input 'Does the staging environment look ok ?'
//       }
//     }

//     stage('create service for green app and make loadbalancer point to it') {
//       steps {
//         withAWS(region: 'us-east-2', credentials: 'MyCredentials') {
//           sh '''
//                       kubectl apply -f ./green-service.yaml
//                    '''
//         }

//       }
//     }

//   }
// }
