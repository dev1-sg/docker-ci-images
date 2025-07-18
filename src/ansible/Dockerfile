# syntax=docker.io/docker/dockerfile:1

FROM public.ecr.aws/dev1-sg/alpine/python:3.13.5 AS base

ARG ANSIBLE_VERSION=11.7.0

USER root

WORKDIR /app

RUN apk add --no-cache dpkg make openssh sshpass libc6-compat

RUN curl -fsSL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_$(case $(uname -m) in x86_64) echo 64bit ;; aarch64) echo arm64 ;; esac)/session-manager-plugin.deb" -o /tmp/session-manager-plugin.deb \
    && dpkg -x /tmp/session-manager-plugin.deb /tmp/session-manager-plugin \
    && mv /tmp/session-manager-plugin/usr/local/sessionmanagerplugin/bin/session-manager-plugin /usr/local/bin/session-manager-plugin

RUN chmod +x /usr/local/bin/session-manager-plugin

RUN rm -rf /var/cache/apk/* /etc/apk/cache/* \
    && ln -s /var/cache/apk /etc/apk/cache \
    && rm -rf /tmp/* \
    && pip3 install --upgrade ansible=="${ANSIBLE_VERSION}"
