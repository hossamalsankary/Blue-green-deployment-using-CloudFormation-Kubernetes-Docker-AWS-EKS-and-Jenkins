#!/bin/bash

blue=$(kubectl get pod,service --namespace=blue-deployment)


if [[ $blue = *pod/blue* ]]
then

echo " prodaction exist "

else

# deploymet
kubectl  create  -f ./k8s/blue-deployment.yaml
# service
kubectl  create  -f ./k8s/blue-service.yaml   

fi


if [[ $blue = *pod/blue* || $blue =  *service/blueservice* ]]
then

echo " blue exist "

else

# deploymet
kubectl  create  -f ./k8s/blue-deployment.yaml
# service
kubectl  create  -f ./k8s/blue-service.yaml   

fi


