# syntax=docker.io/docker/dockerfile:1

FROM docker.io/node:24.2.0-alpine AS base

USER root

ARG YARN_VERSION=1.22.19
ARG PNPM_VERSION=10.11.0

ENV TZ=Asia/Singapore \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    PNPM_HOME="/opt/pnpm"

ENV PATH="${PNPM_HOME}:${PATH}"

WORKDIR /app

RUN corepack enable \
    && corepack prepare pnpm@${PNPM_VERSION} --activate \
    && corepack prepare yarn@${YARN_VERSION} --activate

RUN apk add --no-cache \
    sudo bash git aws-cli curl ca-certificates jq \
    && rm -rf /var/cache/apk/* \
    && ln -s /var/cache/apk /etc/apk/cache
