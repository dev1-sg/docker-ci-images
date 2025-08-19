#!/usr/bin/env bash

cli=$(sed -n 's/^FROM .*:\([0-9.]*\).*/\1/p' Dockerfile.cli | head -1)
dind=$(sed -n 's/^FROM .*:\([0-9.]*\).*/\1/p' Dockerfile.dind | head -1)

export AWS_ECR_PUBLIC_IMAGE_TAG_CLI="${cli}"
export AWS_ECR_PUBLIC_IMAGE_TAG_DIND="${dind}"

if [ -n "$GITHUB_ENV" ]; then
  echo "AWS_ECR_PUBLIC_IMAGE_TAG_CLI=$AWS_ECR_PUBLIC_IMAGE_TAG_CLI" >> $GITHUB_ENV
  echo "AWS_ECR_PUBLIC_IMAGE_TAG_DIND=$AWS_ECR_PUBLIC_IMAGE_TAG_DIND" >> $GITHUB_ENV
else
  echo "AWS_ECR_PUBLIC_IMAGE_TAG_CLI=$AWS_ECR_PUBLIC_IMAGE_TAG_CLI"
  echo "AWS_ECR_PUBLIC_IMAGE_TAG_DIND=$AWS_ECR_PUBLIC_IMAGE_TAG_DIND"
fi
