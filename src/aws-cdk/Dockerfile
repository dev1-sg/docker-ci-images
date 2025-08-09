# syntax=docker.io/docker/dockerfile:1

FROM public.ecr.aws/dev1-sg/alpine/node:24.5.0-3.21 AS base

ARG AWSCDK_VERSION=2.1024.0

RUN npm i -g cdk@${AWSCDK_VERSION}
