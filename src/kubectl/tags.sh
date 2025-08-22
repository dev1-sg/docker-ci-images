#!/usr/bin/env bash

set -e

alpine=$(sed -n 's/^FROM .*:\([0-9.]*\).*/\1/p' Dockerfile.alpine | head -1)
kubectl=$(cat .version)

if [ -z "$alpine" ] || [ -z "$kubectl" ]; then exit 1; fi

export AWS_ECR_PUBLIC_IMAGE_TAG="${kubectl}"
export AWS_ECR_PUBLIC_IMAGE_TAG_ALPINE="${alpine}"

if [ -n "$GITHUB_ENV" ]; then
  echo "AWS_ECR_PUBLIC_IMAGE_TAG=$AWS_ECR_PUBLIC_IMAGE_TAG" >> $GITHUB_ENV
  echo "AWS_ECR_PUBLIC_IMAGE_TAG_ALPINE=$AWS_ECR_PUBLIC_IMAGE_TAG_ALPINE" >> $GITHUB_ENV
else
  echo "AWS_ECR_PUBLIC_IMAGE_TAG=$AWS_ECR_PUBLIC_IMAGE_TAG"
  echo "AWS_ECR_PUBLIC_IMAGE_TAG_ALPINE=$AWS_ECR_PUBLIC_IMAGE_TAG_ALPINE"
fi
