#! /bin/bash

namespaces=$(kubectl get namespaces)


if [[ $namespaces = *green* ]]
then

echo "green deployment exist "

else
echo  " create namespace green deployment "
kubectl create namespace  green-deployment

fi 


if [[ $namespaces = *blue* ]]
then

echo "blue-deployment exist "

else 
echo  " create namespace blue-deployment "
kubectl create namespace  blue-deployment

fi 

