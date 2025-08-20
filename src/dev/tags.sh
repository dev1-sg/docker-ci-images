#!/usr/bin/env bash

export AWS_ECR_PUBLIC_IMAGE_TAG=$(sed -n 's/^FROM .*:\([^ -]*\).*/\1/p' Dockerfile | head -1)

if [ -n "$GITHUB_ENV" ]; then
  echo "AWS_ECR_PUBLIC_IMAGE_TAG=$AWS_ECR_PUBLIC_IMAGE_TAG" >> $GITHUB_ENV
else
  echo "AWS_ECR_PUBLIC_IMAGE_TAG=$AWS_ECR_PUBLIC_IMAGE_TAG"
fi
