#!/usr/bin/env bash

terraform=($(sed -n 's/^ARG TERRAFORM_VERSION=\(.*\)/\1/p' Dockerfile | head -1))

echo "${terraform:-latest}"
