SHELL=/bin/bash

.PHONY: init scaffold

submodule:
	@git submodule update --init --recursive

init:
	@python -m venv .venv
	@source .venv/bin/activate
	@pip install -r requirements.txt

scaffold:
	@python scripts/scaffold.py
