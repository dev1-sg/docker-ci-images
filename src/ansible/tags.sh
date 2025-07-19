#!/usr/bin/env bash

ansible=($(sed -n 's/^ARG ANSIBLE_VERSION=\(.*\)/\1/p' Dockerfile | head -1))

echo "${ansible:-dev}"
