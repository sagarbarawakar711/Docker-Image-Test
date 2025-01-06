#!/bin/bash

REPO_NAME="my-docker-repo"
REGION="ca-central-1"

# Get all image digests, sorted by pushed date (most recent first), excluding the latest 5
IMAGES_TO_DELETE=$(aws ecr describe-images --repository-name "$REPO_NAME" --region "$REGION" --query 'imageDetails | sort_by(@, &imagePushedAt) | [5:] | [].imageDigest' --output text)

# If there are images to delete
if [ ! -z "$IMAGES_TO_DELETE" ]; then
    # Prepare the image digests for deletion
    IMAGE_IDS=$(echo $IMAGES_TO_DELETE | sed 's/ / imageDigest=/g' | sed 's/^/imageDigest=/')
    
    # Delete the old images
    aws ecr batch-delete-image --repository-name "$REPO_NAME" --region "$REGION" --image-ids $IMAGE_IDS
    echo "Deleted the old images."
else
    echo "No images to delete."
fi


