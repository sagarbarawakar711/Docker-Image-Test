#!/bin/bash


REPO_URL="https://github.com/sagarbarawakar711/ArgoCD-Repo.git"
IMAGE_TAG="461655781674.dkr.ecr.ap-south-1.amazonaws.com/argocd-repo:latest"
SECRET_NAME="test/gitrepo"

# Retrieve GitHub Username and Token from AWS Secrets Manager
echo "Retrieving GitHub credentials from AWS Secrets Manager..."
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id $SECRET_NAME --query SecretString --output text)
#
# # Extract GitHub username and token from the secret JSON
GITHUB_USERNAME=$(echo $SECRET_JSON | jq -r '.GITHUB_USERNAME')
GITHUB_TOKEN=$(echo $SECRET_JSON | jq -r '.GITHUB_TOKEN')
#
# # Clone the ArgoCD repository
git clone $REPO_URL
cd ArgoCD-Repo
#
# # Update the deployment.yaml file with the new image tag
sed -i "s|image: .*|image: $IMAGE_TAG|" deployment.yaml
#
# # Configure Git
git config --global user.email "sagarbarawakar1993@gmail.com"
git config --global user.name "Sagar.Barawakar"
#
# # Commit the changes
git add deployment.yaml
git commit -m "Updated image to latest"
#
# # Push the changes using the GitHub username and token from AWS Secrets Manager
echo "Pushing changes to repository..."
git push https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/sagarbarawakar711/ArgoCD-Repo.git
