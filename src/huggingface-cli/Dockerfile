# syntax=docker.io/docker/dockerfile:1

FROM public.ecr.aws/dev1-sg/alpine/uv:3.13.5-3.22.1 AS base

ARG HUGGINGFACEHUB_VERSION=0.34.1

USER root

RUN uv tool install huggingface_hub==${HUGGINGFACEHUB_VERSION}
