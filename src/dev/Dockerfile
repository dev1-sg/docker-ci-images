# syntax=docker.io/docker/dockerfile:1

FROM public.ecr.aws/dev1-sg/alpine/node:24.6.0-alpine3.21 AS node
FROM public.ecr.aws/dev1-sg/alpine/golang:1.25.0-alpine3.21 AS golang
FROM public.ecr.aws/dev1-sg/alpine/python:3.13.7-alpine3.21 AS base

ARG GOLANG_VERSION
ARG PYTHON_VERSION
ARG NODE_VERSION

USER root

ENV GOLANG_VERSION="${GOLANG_VERSION}" \
    PYTHON_VERSION="${PYTHON_VERSION}" \
    NODE_VERSION="${NODE_VERSION}"

ENV PATH="/go/bin:/usr/local/go/bin:${PATH}"

RUN apk add --no-cache aws-cli jq

WORKDIR /builds

FROM base AS final

COPY --from=golang /usr/local/go /usr/local
COPY --from=node /opt /opt
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /usr/local/bin /usr/local/bin

RUN rm -rf /var/cache/apk/*
