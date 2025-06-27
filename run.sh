#!/usr/bin/env bash

env() {
  echo "Exporting .env..."
  cat .env
  export $(grep -v '^#' .env | xargs)
}

submodules() {
  echo "Updating git submodules..."
  git submodule update --init --recursive
  git config --file .gitmodules --get-regexp path | while read -r key submodule_path; do
    echo "Updating submodule at path: $submodule_path"
    (
      cd "$submodule_path" && git pull origin main
    )
  done
}

venv() {
  echo "Setting up venv..."
  python3 -m venv .venv \
  && source .venv/bin/activate \
  && pip install -r requirements.txt
}

readme_main() {
  submodules
  venv
  env
  echo "Generating main readme..."
  python3 scripts/generate_main_readme.py
}

readme_image() {
  submodules
  venv
  env
  echo "Generating image readme..."
  python3 scripts/generate_image_readme.py
}

readme_image_() {
  submodules
  venv
  env
  echo "Generating image readme..."
  python3 scripts/run_image_readme.py "$1"
}

tests() {
  go test ./... -v
}

declare -f "$1" >/dev/null && "$@"
