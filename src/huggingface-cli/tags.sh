#!/usr/bin/env bash

huggingface_hub=($(sed -n 's/^ARG HUGGINGFACEHUB_VERSION=\(.*\)/\1/p' Dockerfile | head -1))

echo "${huggingface_hub:-latest}"
