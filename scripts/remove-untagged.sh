#!/usr/bin/env bash

set -euo pipefail

export AWS_PAGER=""
export AWS_REGION="us-east-1"
export REPOSITORY_GROUP="ci"

REPOSITORIES=$(aws ecr-public describe-repositories \
  --region "$AWS_REGION" \
  | jq -r --arg PREFIX "$REPOSITORY_GROUP" '.repositories[] | select(.repositoryName | startswith($PREFIX + "/")) | .repositoryName')

for REPOSITORY_NAME in $REPOSITORIES; do
  echo "Processing repository: $REPOSITORY_NAME"

  IMAGES=$(aws ecr-public describe-images \
    --repository-name "$REPOSITORY_NAME" \
    --region "$AWS_REGION" \
    | jq -r .imageDetails)

  UNTAGGED_IMAGES=$(jq -r 'map(select(has("imageTags") | not))' <<< "$IMAGES")

  if [[ "$UNTAGGED_IMAGES" == "[]" ]]; then
    echo "No untagged images found in $REPOSITORY_NAME"
    continue
  fi

  IMAGE_DIGESTS=$(jq -r '[.[] | {imageDigest}] | map(.imageDigest) | map("imageDigest=\(.)") | join(" ")' <<< "$UNTAGGED_IMAGES")

  echo "Deleting untagged images from $REPOSITORY_NAME..."
  aws ecr-public batch-delete-image \
    --repository-name "$REPOSITORY_NAME" \
    --image-ids $IMAGE_DIGESTS \
    --region "$AWS_REGION"
done
