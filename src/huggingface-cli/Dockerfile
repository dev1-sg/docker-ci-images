# syntax=docker.io/docker/dockerfile:1

FROM public.ecr.aws/dev1-sg/alpine/python:3.13.6-3.21 AS base

ARG HUGGINGFACE_VERSION=0.34.1

RUN pip3 install --upgrade huggingface_hub==${HUGGINGFACE_VERSION}
