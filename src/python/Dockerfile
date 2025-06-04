# syntax=docker.io/docker/dockerfile:1

FROM docker.io/python:3.13.4-alpine AS base

ARG POETRY_VERSION=2.1.3

USER root

ENV HOME=/root \
    TZ=Asia/Singapore \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR="${HOME}/.cache/pypoetry" \
    POETRY_HOME=/opt/poetry

ENV PATH="${POETRY_HOME}/bin:${POETRY_HOME}/.venv/bin:${PATH}"

WORKDIR /app

RUN apk add --no-cache \
    sudo bash git aws-cli curl ca-certificates jq \
    && rm -rf /var/cache/apk/* \
    && ln -s /var/cache/apk /etc/apk/cache

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir poetry
