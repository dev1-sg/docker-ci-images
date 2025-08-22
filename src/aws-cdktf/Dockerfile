# syntax=docker.io/docker/dockerfile:1

FROM public.ecr.aws/dev1-sg/alpine/python:3.13.7-alpine3.21 AS base

USER root

RUN apk add --no-cache aws-cli jq

WORKDIR /builds

FROM public.ecr.aws/dev1-sg/alpine/node:24.5.0-alpine3.21 AS build

COPY --from=base /usr/local/bin /usr/local/bin
COPY --from=base /usr/local/lib /usr/local/lib

ARG CDKTF_VERSION=0.21.0
ARG AWSCDK_VERSION=2.1026.0
ARG TERRAFORM_VERSION=1.13.0
ARG TERRAGRUNT_VERSION=0.86.0
ARG TERRAFORM_DOCS_VERSION=0.20.0

RUN apk add --no-cache unzip tar gzip make build-base

RUN npm i -g cdktf-cli@${CDKTF_VERSION} aws-cdk@${AWSCDK_VERSION}

RUN curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_$(case $(uname -m) in x86_64) echo amd64 ;; aarch64) echo arm64 ;; esac).zip" -o /tmp/terraform.zip \
    && unzip /tmp/terraform.zip -d /tmp \
    && cp /tmp/terraform /usr/local/bin/terraform \
    && chmod +x /usr/local/bin/terraform

RUN curl -fsSL "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_$(case $(uname -m) in x86_64) echo amd64 ;; aarch64) echo arm64 ;; esac)" -o /tmp/terragrunt \
    && cp /tmp/terragrunt /usr/local/bin/terragrunt \
    && chmod +x /usr/local/bin/terragrunt

RUN curl -fsSL "https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-$(case $(uname -m) in x86_64) echo amd64 ;; aarch64) echo arm64 ;; esac).tar.gz" -o /tmp/terraform-docs.tar.gz \
    && tar -xvf /tmp/terraform-docs.tar.gz -C /tmp \
    && cp /tmp/terraform-docs /usr/local/bin/terraform-docs \
    && chmod +x /usr/local/bin/terraform-docs

FROM base AS final

COPY --from=build /opt /opt
COPY --from=build /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=build /usr/local/bin /usr/local/bin

RUN rm -rf /var/cache/apk/*
