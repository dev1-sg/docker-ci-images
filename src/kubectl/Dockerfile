# syntax=docker.io/docker/dockerfile:1

FROM public.ecr.aws/dev1-sg/ci/alpine:3.21 AS base

FROM base AS build

ARG HELM_VERSION=3.17.0
ARG KUBECTL_VERSION=1.32.0

RUN apk add --no-cache tar

RUN curl -fsSL "https://get.helm.sh/helm-v${HELM_VERSION}-rc.1-linux-$(case $(uname -m) in x86_64) echo amd64 ;; aarch64) echo arm64 ;; esac).tar.gz" -o /tmp/helm.tar.gz \
    && tar -xvf /tmp/helm.tar.gz -C /tmp \
    && cp "/tmp/linux-$(case $(uname -m) in x86_64) echo amd64 ;; aarch64) echo arm64 ;; esac)/helm" /usr/local/bin

RUN curl -fsSL "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/$(case $(uname -m) in x86_64) echo amd64 ;; aarch64) echo arm64 ;; esac)/kubectl" -o /usr/local/bin/kubectl

FROM base AS final

COPY --from=build /usr/local/bin/helm /usr/local/bin/helm
COPY --from=build /usr/local/bin/kubectl /usr/local/bin/kubectl

RUN chmod +x /usr/local/bin/helm /usr/local/bin/kubectl
