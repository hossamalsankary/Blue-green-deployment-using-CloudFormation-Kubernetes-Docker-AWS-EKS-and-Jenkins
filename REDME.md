<img src="/Blank diagram(2).png" alt="Permissions" />
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
