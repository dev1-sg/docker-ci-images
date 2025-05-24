# syntax=docker.io/docker/dockerfile:1

FROM docker.io/python:3.13.3-alpine AS base

USER root

ARG POETRY_VERSION=2.1.3

ENV TZ=Asia/Singapore \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VENV="/opt/poetry/venv" \
    POETRY_CACHE_DIR="/opt/poetry/cache" \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false

ENV PATH="${POETRY_HOME}/bin:${PATH}"

WORKDIR /app

RUN apk add --no-cache \
    sudo bash git aws-cli curl ca-certificates jq \
    && rm -rf /var/cache/apk/* \
    && ln -s /var/cache/apk /etc/apk/cache

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir poetry
