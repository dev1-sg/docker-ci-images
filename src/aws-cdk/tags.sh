#!/usr/bin/env bash

aws_cdk=($(sed -n 's/^ARG AWSCDK_VERSION=\(.*\)/\1/p' Dockerfile | head -1))

echo "${aws_cdk:-latest}"
