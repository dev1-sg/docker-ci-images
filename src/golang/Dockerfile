# syntax=docker.io/docker/dockerfile:1

FROM docker.io/golang:1.24.3-alpine AS base

USER root

ENV TZ=Asia/Singapore \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    GOPATH="/go" \
    GOTOOLCHAIN="local"

ENV PATH="${GOPATH}/bin:/usr/local/go/bin:${PATH}"

WORKDIR /go

RUN apk add --no-cache \
    sudo bash git aws-cli curl ca-certificates jq \
    && rm -rf /var/cache/apk/* \
    && ln -s /var/cache/apk /etc/apk/cache
