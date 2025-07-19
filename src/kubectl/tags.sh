#!/usr/bin/env bash

kubectl=($(sed -n 's/^ARG KUBECTL_VERSION=\(.*\)/\1/p' Dockerfile | head -1))

echo "${kubectl:-dev}"
