#!/bin/bash

# Build Docker images
docker build -t rajendrarathore/app1:latest apps/app1
docker build -t rajendrarathore/app2:latest apps/app2

# Push Docker images to Docker Hub
docker push rajendrarathore/app1:latest
docker push rajendrarathore/app2:latest

# Apply Kubernetes manifests
kubectl apply -f k8s/app1-deployment.yaml
kubectl apply -f k8s/app2-deployment.yaml

# Wait for deployments to be ready
kubectl rollout status deployment/app1
kubectl rollout status deployment/app2

# Get HTTP responses from the applications
echo "Response from app1:"
kubectl exec $(kubectl get pods -l app=aap1 --no-headers -o custom-columns=":metadata.name") -- curl -s http://localhost:6000/

echo "Response from app2:"
kubectl exec $(kubectl get pods  app=aap2 --no-headers -o custom-columns=":metadata.name") -- curl -s http://localhost:6001/
