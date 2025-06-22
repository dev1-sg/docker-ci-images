# syntax=docker.io/docker/dockerfile:1

FROM public.ecr.aws/dev1-sg/base/alpine:3.21 AS base

FROM base AS build

ARG TERRAFORM_VERSION=1.12.0
ARG TERRAGRUNT_VERSION=0.78.4
ARG TERRAFORM_DOCS_VERSION=0.20.0

RUN apk add --no-cache unzip tar

RUN curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_$(case $(uname -m) in x86_64) echo amd64 ;; aarch64) echo arm64 ;; esac).zip" -o /tmp/terraform.zip \
    && unzip /tmp/terraform.zip -d /tmp \
    && cp /tmp/terraform /usr/local/bin/terraform

RUN curl -fsSL "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_$(case $(uname -m) in x86_64) echo amd64 ;; aarch64) echo arm64 ;; esac)" -o /tmp/terragrunt \
    && cp /tmp/terragrunt /usr/local/bin/terragrunt

RUN curl -fsSL "https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-$(case $(uname -m) in x86_64) echo amd64 ;; aarch64) echo arm64 ;; esac).tar.gz" -o /tmp/terraform-docs.tar.gz \
    && tar -xvf /tmp/terraform-docs.tar.gz -C /tmp \
    && cp /tmp/terraform-docs /usr/local/bin/terraform-docs

FROM base AS final

COPY --from=build /usr/local/bin/terraform /usr/local/bin/terraform
COPY --from=build /usr/local/bin/terragrunt /usr/local/bin/terragrunt
COPY --from=build /usr/local/bin/terraform-docs /usr/local/bin/terraform-docs

RUN chmod +x /usr/local/bin/terraform /usr/local/bin/terragrunt /usr/local/bin/terraform-docs
