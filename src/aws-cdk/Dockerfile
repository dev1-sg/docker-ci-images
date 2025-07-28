# syntax=docker.io/docker/dockerfile:1

FROM public.ecr.aws/dev1-sg/alpine/uv:3.13.5-3.22.1 AS base

ARG AWSCDK_VERSION=2.1022.0

USER root

RUN uv tool install aws-cdk-cli==${AWSCDK_VERSION}
