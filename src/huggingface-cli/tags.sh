#!/usr/bin/env bash

huggingface=($(sed -n 's/^ARG HUGGINGFACE_VERSION=\(.*\)/\1/p' Dockerfile | head -1))

echo "${huggingface:-latest}"
