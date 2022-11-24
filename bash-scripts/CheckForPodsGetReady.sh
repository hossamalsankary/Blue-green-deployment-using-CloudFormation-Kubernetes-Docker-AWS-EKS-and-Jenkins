#!/bin/bash
function watchPods(){
echo 'inidata' > green
echo 'inidata' > blue

(kubectl wait pods -n default -l app=green --for condition=Ready --timeout=90s --namespace=green-deployment |   tr -d "/") 1> green 2>err

(kubectl wait pods -n default -l app=blue --for condition=Ready --timeout=90s --namespace=blue-deployment |   tr -d "/") 1> blue 2>blue
}

watchPods  
cat green
while [[ ($(cat green) != *met*) || ($(cat blue) != *met*) ]]
do
    if [[ $(cat green) != *met* ]]
    then
    echo "waiting for green pods to get redy !! "
    fi
    if [[ $(cat blue) != *met* ]]
    then
        echo "waiting for blue pods to get redy !! "
    fi
sleep 10
watchPods

done
