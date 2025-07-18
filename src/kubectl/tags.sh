#!/usr/bin/env bash

sed -n 's/^ARG KUBECTL_VERSION=\(.*\)/\1/p' Dockerfile | head -1
