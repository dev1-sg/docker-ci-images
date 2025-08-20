# syntax=docker.io/docker/dockerfile:1

FROM docker.io/alpine:3.22 AS base

USER root

ENV TZ=Asia/Singapore \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN apk add --no-cache bash

WORKDIR /workspace
