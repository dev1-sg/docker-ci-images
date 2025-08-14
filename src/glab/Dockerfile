# syntax=docker.io/docker/dockerfile:1

FROM public.ecr.aws/dev1-sg/alpine/alpine:3.22 AS base

FROM base AS build

ARG GLAB_VERSION=1.67.0

RUN apk add --no-cache tar gzip

RUN curl -fsSL "https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VERSION}/downloads/glab_${GLAB_VERSION}_linux_$(case $(uname -m) in x86_64) echo amd64 ;; aarch64) echo arm64 ;; esac).tar.gz" -o /tmp/glab.tar.gz \
    && tar -xvf /tmp/glab.tar.gz -C /tmp \
    && cp /tmp/bin/glab /usr/local/bin/glab \
    && chmod +x /usr/local/bin/glab

FROM base AS final

COPY --from=build /usr/local/bin /usr/local/bin
