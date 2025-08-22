#!/usr/bin/env bash

set -e

alpine=$(sed -n 's/^FROM .*:\([^ -]*\).*/\1/p' Dockerfile | head -1)

if [ -z "$alpine" ]; then exit 1; fi

export AWS_ECR_PUBLIC_IMAGE_TAG="${alpine}"

if [ -n "$GITHUB_ENV" ]; then
  echo "AWS_ECR_PUBLIC_IMAGE_TAG=$AWS_ECR_PUBLIC_IMAGE_TAG" >> $GITHUB_ENV
else
  echo "AWS_ECR_PUBLIC_IMAGE_TAG=$AWS_ECR_PUBLIC_IMAGE_TAG"
fi
