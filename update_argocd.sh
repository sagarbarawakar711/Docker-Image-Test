#!/bin/bash

# Variables
REPO_URL="https://github.com/sagarbarawakar711/ArgoCD-Repo.git"
IMAGE_TAG="461655781674.dkr.ecr.ap-south-1.amazonaws.com/argocd-repo:latest"

# Clone the ArgoCD repository
git clone $REPO_URL
cd ArgoCD-Repo

# Update the deployment.yaml file with the new image tag
sed -i "s|image: .*|image: $IMAGE_TAG|" deployment.yaml

# Configure Git
git config --global user.email "sagarbarawakar1993@gmail.com"
git config --global user.name "Sagar.Barawakar"

# Commit and push the changes
git add deployment.yaml
git commit -m "Updated image to latest"
echo connecting to repo
git remote set-url origin https://sagarbarawakar711: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@github.com/sagarbarawakar711/ArgoCD-Repo.git
git push origin main
