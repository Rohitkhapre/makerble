#!/bin/bash

NAMESPACE="devops-app"

echo "🔧 Creating namespace: $NAMESPACE..."
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

echo "🔐 Creating Kubernetes secrets..."
kubectl create secret generic db-credentials \
  --from-literal=db_user=railsuser \
  --from-literal=db_password=securepassword \
  -n $NAMESPACE

kubectl create secret generic postgres-secret \
  --from-literal=username=railsuser \
  --from-literal=password=securepassword \
  -n $NAMESPACE

echo "📦 Applying PostgreSQL StatefulSet and Service..."
kubectl apply -f k8s/postgres/statefulset.yaml -n $NAMESPACE
kubectl apply -f k8s/postgres/service.yaml -n $NAMESPACE

echo "🚀 Deploying Rails application..."
kubectl apply -f k8s/rails/deployment.yaml -n $NAMESPACE
kubectl apply -f k8s/rails/service.yaml -n $NAMESPACE

echo "🌐 Applying Ingress (if configured)..."
kubectl apply -f k8s/ingress.yaml -n $NAMESPACE

echo "✅ Done! You can check the status using:"
echo "    kubectl get pods -n $NAMESPACE"
echo "    kubectl logs <pod-name> -n $NAMESPACE"

