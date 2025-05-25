# syntax=docker.io/docker/dockerfile:1

FROM public.ecr.aws/dev1-sg/ci/alpine:3.21 AS base

FROM base AS build

ARG PACKER_VERSION=1.11.2

RUN apk add --no-cache unzip

RUN curl -fsSL "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_$(case $(uname -m) in x86_64) echo amd64 ;; aarch64) echo arm64 ;; esac).zip" -o /tmp/packer.zip \
    && unzip /tmp/packer.zip -d /tmp \
    && cp /tmp/packer /usr/local/bin/packer

FROM base AS final

COPY --from=build /usr/local/bin/packer /usr/local/bin/packer

RUN chmod +x /usr/local/bin/packer
