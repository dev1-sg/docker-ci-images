#!/usr/bin/env bash

version=($(cat version | head -1))

echo "${version:-latest}"
