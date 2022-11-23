#!/bin/bash

blue=$(kubectl get pod,service --namespace=blue-deployment)


if [[ $blue = *pod/blue* ]]
then

echo " prodaction exist "

else

cat ../k8s/blue-deployment.yaml
# deploymet
kubectl  create  -f ./k8s/blue-deployment.yaml
# service
kubectl  create  -f ./k8s/blue-service.yaml   

fi



