#!/usr/bin/env bash

docker=($(sed -n 's/^FROM .*:\([^ -]*\).*/\1/p' Dockerfile | head -1))

echo "${docker:-latest}"
