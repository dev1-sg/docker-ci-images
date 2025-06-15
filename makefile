SHELL=/bin/bash

.PHONY: init scaffold

init:
	@python -m venv .venv
	@source .venv/bin/activate
	@pip install -r requirements.txt

scaffold:
	@python scripts/scaffold.py
