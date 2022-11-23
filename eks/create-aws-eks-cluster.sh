#!/usr/bin/env bash
#step1 create aws eks cluster
eksctl create cluster \
  --name jenkinstest2 \
  --region us-east-2 \
  --version 1.18 \
  --node-type t2.micro \
  --nodes 3 \
  --nodes-min 1 \
  --nodes-max 4 \
  --managed
  
#step2 create kubeconfig file to store info of cluster so we can access it later and communicate with it using kubectl 
aws eks --region us-east-2 update-kubeconfig --name jenkinstest2
