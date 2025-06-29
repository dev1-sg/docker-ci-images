#!/usr/bin/env bash

sed -n 's/^FROM .*:\([^ -]*\).*/\1/p' Dockerfile | head -1
