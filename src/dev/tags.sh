#!/usr/bin/env bash

set -e

version=$(cat .version)

if [ -z "$version" ]; then exit 1; fi

export AWS_ECR_PUBLIC_IMAGE_TAG="${version}"

if [ -n "$GITHUB_ENV" ]; then
  echo "AWS_ECR_PUBLIC_IMAGE_TAG=$AWS_ECR_PUBLIC_IMAGE_TAG" >> $GITHUB_ENV
else
  echo "AWS_ECR_PUBLIC_IMAGE_TAG=$AWS_ECR_PUBLIC_IMAGE_TAG"
fi
