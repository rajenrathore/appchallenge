#!/bin/bash

#last hash file for both app1 and ap2
HASH_FILE_app1=".last_build_hash_app1"
HASH_FILE_app2=".last_build_hash_app2"

# Calculate the current hash app1 ans app2 sourcefiles
app1_HASH=$(find apps/app1 -type f -exec md5sum {} + | md5sum | awk '{ print $1 }')
app2_HASH=$(find apps/app2 -type f -exec md5sum {} + | md5sum | awk '{ print $1 }')

# Check if the app1 hash file exists
if [ -f "$HASH_FILE_app1" ]; then
    APP1_LAST_HASH=$(cat "$HASH_FILE_app1")
else
    APP1_LAST_HASH=""
fi

# Check if the app2 hash file exists
if [ -f "$HASH_FILE_app2" ]; then
    APP2_LAST_HASH=$(cat "$HASH_FILE_app2")
else
    APP2_LAST_HASH=""
fi

# Compare hashes for app1
if [ "$app1_HASH" == "$APP1_LAST_HASH" ]; then
    echo "No changes detected. Skipping image build."
else
    echo "Changes detected. Building image..."
    docker build -t rajendrarathore/app1:latest apps/app1
    echo "$app1_HASH" > "$HASH_FILE_app1"  # Update the hash file
    docker push rajendrarathore/app1:latest ##push docker image app1
    helm uninstall app1 ./app1-chart # uninstall hrlm app1
fi

# Compare hashes for app2
if [ "$app2_HASH" == "$APP2_LAST_HASH" ]; then
    echo "No changes detected. Skipping image build."
else
    echo "Changes detected. Building image..."
    docker build -t rajendrarathore/app2:latest apps/app2
    echo "$app2_HASH" > "$HASH_FILE_app2"  # Update the hash file
    docker push rajendrarathore/app2:latest #push docker image app2
    helm uninstall app2 ./app2-chart # uninstall helm app2
fi
# Build Docker images
#docker build -t rajendrarathore/app1:latest apps/app1
#docker build -t rajendrarathore/app2:latest apps/app2

# Push Docker images to Docker Hub
#docker push rajendrarathore/app1:latest
#docker push rajendrarathore/app2:latest

# Apply Kubernetes manifests
#kubectl apply -f k8s/app1-deployment.yaml
#kubectl apply -f k8s/app2-deployment.yaml
if helm ls --all --short | grep -q app1; then
  echo "Helm release app1 already existing. skipping install"
else
  echo "installing app1"
  helm install app1 ./app1-chart
fi

if helm ls --all --short | grep -q app2; then
  echo "Helm release app2 already existing. skipping install"
else
  echo "installing app2"
  helm install app2 ./app2-chart
fi
# Wait for deployments to be ready
kubectl rollout status deployment/app1
kubectl rollout status deployment/app2

# Get HTTP responses from the applications
echo "Response from app1:"
kubectl exec $(kubectl get pods -l app=app1 --no-headers -o custom-columns=":metadata.name") -- curl -s http://localhost:6000/

echo "Response from app2:"
kubectl exec $(kubectl get pods -l app=app2 --no-headers -o custom-columns=":metadata.name") -- curl -s http://localhost:6001/
