# syntax=docker/dockerfile:1

FROM docker.io/node:24.4.0-alpine3.21 AS node
FROM docker.io/python:3.13.5-alpine3.21 AS python
FROM docker.io/docker:28.2.2-dind-alpine3.21 AS base

ARG AWSCDK_VERSION=2.1020.2

USER root

ENV TZ=Asia/Singapore \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN apk add --no-cache \
    bash git aws-cli curl ca-certificates jq docker \
    && rm -rf /var/cache/apk/* \
    && ln -s /var/cache/apk /etc/apk/cache

COPY --from=node /usr/local/bin /usr/local/bin
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=python /usr/local/bin /usr/local/bin
COPY --from=python /usr/local/lib /usr/local/lib

RUN npm install -g aws-cdk@${AWSCDK_VERSION}
