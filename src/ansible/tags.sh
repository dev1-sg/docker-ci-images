#!/usr/bin/env bash

sed -n 's/^ARG ANSIBLE_VERSION=\(.*\)/\1/p' Dockerfile | head -1
