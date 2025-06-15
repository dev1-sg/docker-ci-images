#!/usr/bin/env bash

git submodule update --init --recursive \
&& cd shared && git pull origin main && cd ..

python -m venv .venv \
&& source .venv/bin/activate \
&& pip install -r requirements.txt
