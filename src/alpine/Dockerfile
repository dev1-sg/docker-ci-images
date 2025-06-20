# syntax=docker.io/docker/dockerfile:1

FROM public.ecr.aws/dev1-sg/base/alpine:3.22 AS base

RUN apk add --no-cache \
    sudo bash git aws-cli curl ca-certificates jq \
    && rm -rf /var/cache/apk/* \
    && ln -s /var/cache/apk /etc/apk/cache
