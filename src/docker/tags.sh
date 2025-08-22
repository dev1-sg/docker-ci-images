#!/usr/bin/env bash

set -e

cli=$(sed -n 's/^FROM .*:\([0-9.]*\).*/\1/p' Dockerfile.cli | head -1)
dind=$(sed -n 's/^FROM .*:\([0-9.]*\).*/\1/p' Dockerfile.dind | head -1)

if [ -z "$cli" ] || [ -z "$dind" ]; then exit 1; fi

export AWS_ECR_PUBLIC_IMAGE_TAG_CLI="${cli}"
export AWS_ECR_PUBLIC_IMAGE_TAG="${dind}"

if [ -n "$GITHUB_ENV" ]; then
  echo "AWS_ECR_PUBLIC_IMAGE_TAG_CLI=$AWS_ECR_PUBLIC_IMAGE_TAG_CLI" >> $GITHUB_ENV
  echo "AWS_ECR_PUBLIC_IMAGE_TAG=$AWS_ECR_PUBLIC_IMAGE_TAG" >> $GITHUB_ENV
else
  echo "AWS_ECR_PUBLIC_IMAGE_TAG_CLI=$AWS_ECR_PUBLIC_IMAGE_TAG_CLI"
  echo "AWS_ECR_PUBLIC_IMAGE_TAG=$AWS_ECR_PUBLIC_IMAGE_TAG"
fi
