# blue-green deployment project using cloudformation , kubernetes , docker , aws EKS , jenkins
## skills:
1. Working in AWS
2. Using Jenkins to implement Continuous Integration and Continuous Deployment
3. Building pipelines
4. Working with CloudFormation to deploy clusters
5. Building Kubernetes clusters
6. Building Docker containers in pipelines

### scenario:
1. create AWS EC2 instance and install Jenkins, docker on it 
2. make IAM user with admin privilege and use it for the jenkins-aws connection
3. install dockerhub and AWS pipeline plugins on Jenkins and add their credentials
4. create aws cluster by running create-aws-eks-cluster.sh 
5. run jenkinsfile which will build docker image and upload it to dockerhub and then create 2 stages blue and green deployment and run the blue deployment using blue-service which is a kubernetes loadbalancer pointing to the blue deployment using code `selector=blue` then check if the green environment is ready for being used if yes jenkins will run green-service which will point loadbalancer to the green deployment using code `selector=green'

#### proven steps:
1. 3 node-cluster created: 

![Screenshot from 2020-11-06 07-01-09](https://user-images.githubusercontent.com/68178003/100597953-c4d44c80-3306-11eb-8d21-42741086cf0e.png)

2. pipeline : 

![Screenshot from 2020-11-02 15-21-17](https://user-images.githubusercontent.com/68178003/100597938-bc7c1180-3306-11eb-9386-c871e3184bad.png)

3. checking and asking user to accept before directing traffic to the green app 

![Screenshot from 2020-11-02 15-24-11](https://user-images.githubusercontent.com/68178003/100597943-bf770200-3306-11eb-80d2-fd839168fc9b.png)

4. all pipeline finished successfully

![Screenshot from 2020-11-02 15-24-45](https://user-images.githubusercontent.com/68178003/100597950-c1d95c00-3306-11eb-81f8-8ad0a518c569.png)

5. loadbalancers created 
![Screenshot from 2020-11-06 07-13-45](https://user-images.githubusercontent.com/68178003/100597972-c867d380-3306-11eb-9a19-b935774cb24f.png)

![Screenshot from 2020-11-06 07-14-16](https://user-images.githubusercontent.com/68178003/100597983-cbfb5a80-3306-11eb-9b23-2e028f5fa85d.png)

# Blue-green-deployment-using-CloudFormation-Kubernetes-Docker-AWS-EKS-and-Jenkins.
# Blue-green-deployment-using-CloudFormation-Kubernetes-Docker-AWS-EKS-and-Jenkins.
# Blue-green-deployment-using-CloudFormation-Kubernetes-Docker-AWS-EKS-and-Jenkins.
