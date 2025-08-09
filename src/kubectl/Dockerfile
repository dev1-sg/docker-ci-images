# syntax=docker.io/docker/dockerfile:1

FROM public.ecr.aws/dev1-sg/alpine/alpine:3.22 AS base

FROM base AS build

ARG KUBECTL_VERSION=1.33.1
ARG HELM_VERSION=3.18.4
ARG KUSTOMIZE_VERSION=5.7.0

RUN apk add --no-cache unzip tar

RUN curl -fsSL "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/$(case $(uname -m) in x86_64) echo amd64 ;; aarch64) echo arm64 ;; esac)/kubectl" -o /tmp/kubectl \
    && cp /tmp/kubectl /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

RUN curl -fsSL "https://get.helm.sh/helm-v${HELM_VERSION}-linux-$(case $(uname -m) in x86_64) echo amd64 ;; aarch64) echo arm64 ;; esac).tar.gz" -o /tmp/helm.tar.gz \
    && tar -xf /tmp/helm.tar.gz -C /tmp --strip-components=1 "linux-$(case $(uname -m) in x86_64) echo amd64 ;; aarch64) echo arm64 ;; esac)/helm" \
    && cp /tmp/helm /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm

RUN curl -fsSL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_$(case $(uname -m) in x86_64) echo amd64 ;; aarch64) echo arm64 ;; esac).tar.gz" -o /tmp/kustomize.tar.gz \
    && tar -xvf /tmp/kustomize.tar.gz -C /tmp \
    && cp /tmp/kustomize /usr/local/bin/kustomize \
    && chmod +x /usr/local/bin/kustomize

FROM base AS final

COPY --from=build /usr/local/bin /usr/local/bin
