# syntax=docker.io/docker/dockerfile:1

FROM public.ecr.aws/dev1-sg/alpine/alpine:3.22 AS base

USER root

RUN apk add --no-cache aws-cli jq \
    && rm -rf /var/cache/apk/*

WORKDIR /builds
