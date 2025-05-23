#!/bin/bash
# 確認 current-context
kubectl config current-context

read -p "Are you sure you want to destroy? (y/n): " confirm
if [[ $confirm != "y" ]]; then
  echo "Destroy cancelled."
  exit 1
fi

echo "Destroying deployment..."
kubectl delete -f deployment_curl.yaml -n test

echo "Destroying namespace..."
kubectl delete namespace test