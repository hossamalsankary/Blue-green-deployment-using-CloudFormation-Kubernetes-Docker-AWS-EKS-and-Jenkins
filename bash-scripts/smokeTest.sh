#!/bin/bash
export blueIP=$(kubectl get services --namespace=blue-deployment  blueservice --output jsonpath='{.status.loadBalancer.ingress[0]}'| tr -d '"' | tr -d '}' | cut -d ':' -f 2 )
export greenIP=$(kubectl get services --namespace=green-deployment  greenservice --output jsonpath='{.status.loadBalancer.ingress[0]}'| tr -d '"' | tr -d '}' | cut -d ':' -f 2 )
curl 'http://$blueIP:8080'
curl 'http://$greenIP:8080'