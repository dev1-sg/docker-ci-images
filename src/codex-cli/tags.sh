#!/usr/bin/env bash

codex=($(sed -n 's/^ARG CODEX_VERSION=\(.*\)/\1/p' Dockerfile | head -1))

echo "${codex:-latest}"
