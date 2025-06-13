# syntax=docker.io/docker/dockerfile:1

FROM docker.io/python:3.13.5-alpine AS base

USER root

ENV HOME=/root \
    TZ=Asia/Singapore \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

WORKDIR /app

RUN apk add --no-cache \
    sudo bash git aws-cli curl ca-certificates jq \
    && rm -rf /var/cache/apk/* \
    && ln -s /var/cache/apk /etc/apk/cache

RUN pip install --no-cache-dir --upgrade pip
