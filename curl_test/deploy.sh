#!/bin/bash
# 確認 current-context
kubectl config current-context

read -p "Are you sure you want to deploy? (y/n): " confirm
if [[ $confirm != "y" ]]; then
  echo "Deployment cancelled."
  exit 1
fi

echo "Createing namespace..."
kubectl create namespace test

echo "Starting deployment..."
kubectl apply -f deployment_curl.yaml -n test