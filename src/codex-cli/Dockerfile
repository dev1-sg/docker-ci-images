# syntax=docker.io/docker/dockerfile:1

FROM public.ecr.aws/dev1-sg/alpine/node:24.5.0-3.21 AS base

ARG CODEX_VERSION=0.21.0

USER root

RUN npm install -g @openai/codex@${CODEX_VERSION} \
    && mkdir -p /root/.codex

COPY config.toml /root/.codex
