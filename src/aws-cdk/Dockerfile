# syntax=docker.io/docker/dockerfile:1

FROM public.ecr.aws/dev1-sg/alpine/uv:3.13.5-3.22.1 AS base

FROM base AS build

ARG NODE_VERSION=24.0.1

RUN apk add curl tar xz \
    && curl -fL "https://unofficial-builds.nodejs.org/download/release/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64-musl.tar.gz" -o /tmp/node.tar.gz \
    && tar --strip-components=1 -xvf /tmp/node.tar.gz -C /usr/local/ --wildcards '*/bin/*' '*/lib/*' '*/include/*' '*/share/*'

FROM base AS final

ARG AWSCDK_VERSION=2.1022.0

COPY --from=build /usr/local /usr/local

RUN uv tool install aws-cdk-cli==${AWSCDK_VERSION}
