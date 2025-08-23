#!/usr/bin/env bash

set -e

version=$(cat .version)
golang=$(sed -n 's|.*golang:\([0-9]\+\.[0-9]\+\.[0-9]\+\).*|\1|p' Dockerfile | head -1)
python=$(sed -n 's|.*python:\([0-9]\+\.[0-9]\+\.[0-9]\+\).*|\1|p' Dockerfile | head -1)
node=$(sed -n 's|.*node:\([0-9]\+\.[0-9]\+\.[0-9]\+\).*|\1|p' Dockerfile | head -1)

if [ -z "$version" ] || [ -z "$python" ] || [ -z "$node" ] || [ -z $golang ]; then exit 1; fi

export AWS_ECR_PUBLIC_IMAGE_TAG="${version}"
export AWS_ECR_PUBLIC_IMAGE_TAG_GOLANG="${golang}"
export AWS_ECR_PUBLIC_IMAGE_TAG_PYTHON="${python}"
export AWS_ECR_PUBLIC_IMAGE_TAG_NODE="${node}"

if [ -n "$GITHUB_ENV" ]; then
  echo "AWS_ECR_PUBLIC_IMAGE_TAG=$AWS_ECR_PUBLIC_IMAGE_TAG" >> $GITHUB_ENV
  echo "AWS_ECR_PUBLIC_IMAGE_TAG_GOLANG=$AWS_ECR_PUBLIC_IMAGE_TAG_GOLANG" >> $GITHUB_ENV
  echo "AWS_ECR_PUBLIC_IMAGE_TAG_PYTHON=$AWS_ECR_PUBLIC_IMAGE_TAG_PYTHON" >> $GITHUB_ENV
  echo "AWS_ECR_PUBLIC_IMAGE_TAG_NODE=$AWS_ECR_PUBLIC_IMAGE_TAG_NODE" >> $GITHUB_ENV
else
  echo "AWS_ECR_PUBLIC_IMAGE_TAG=$AWS_ECR_PUBLIC_IMAGE_TAG"
  echo "AWS_ECR_PUBLIC_IMAGE_TAG_GOLANG=$AWS_ECR_PUBLIC_IMAGE_TAG_GOLANG"
  echo "AWS_ECR_PUBLIC_IMAGE_TAG_PYTHON=$AWS_ECR_PUBLIC_IMAGE_TAG_PYTHON"
  echo "AWS_ECR_PUBLIC_IMAGE_TAG_NODE=$AWS_ECR_PUBLIC_IMAGE_TAG_NODE"
fi
