#!/usr/bin/env bash

git submodule update --init --recursive

python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
