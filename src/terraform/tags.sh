#!/usr/bin/env bash

sed -n 's/^ARG TERRAFORM_VERSION=\(.*\)/\1/p' Dockerfile | head -1
