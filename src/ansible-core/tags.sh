#!/usr/bin/env bash

alpine=$(sed -n 's/^FROM .*:\([^-]*-\)\([^- ]*\).*/\2/p' Dockerfile.alpine | head -1)
debian=$(sed -n 's/^FROM .*:\([0-9.]*-\)\?\([^ ]*\).*/\2/p' Dockerfile.debian | head -1)
ansible=$(cat .version)

export AWS_ECR_PUBLIC_IMAGE_TAG="${ansible}"
export AWS_ECR_PUBLIC_IMAGE_TAG_ALPINE="${ansible}-alpine${alpine}"
export AWS_ECR_PUBLIC_IMAGE_TAG_DEBIAN="${ansible}-${debian}"

if [ -n "$GITHUB_ENV" ]; then
  echo "AWS_ECR_PUBLIC_IMAGE_TAG=$AWS_ECR_PUBLIC_IMAGE_TAG" >> $GITHUB_ENV
  echo "AWS_ECR_PUBLIC_IMAGE_TAG_ALPINE=$AWS_ECR_PUBLIC_IMAGE_TAG_ALPINE" >> $GITHUB_ENV
  echo "AWS_ECR_PUBLIC_IMAGE_TAG_DEBIAN=$AWS_ECR_PUBLIC_IMAGE_TAG_DEBIAN" >> $GITHUB_ENV
else
  echo "AWS_ECR_PUBLIC_IMAGE_TAG=$AWS_ECR_PUBLIC_IMAGE_TAG"
  echo "AWS_ECR_PUBLIC_IMAGE_TAG_ALPINE=$AWS_ECR_PUBLIC_IMAGE_TAG_ALPINE"
  echo "AWS_ECR_PUBLIC_IMAGE_TAG_DEBIAN=$AWS_ECR_PUBLIC_IMAGE_TAG_DEBIAN"
fi
