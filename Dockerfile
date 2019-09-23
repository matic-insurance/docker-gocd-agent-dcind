ARG GOCD_VERSION=v19.8.0

# Amazon ECR credential-helper
FROM golang:1.12-alpine AS ecr-credentials

RUN apk --no-cache add git \
  && go get -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login

# GOCD image
FROM gocd/gocd-agent-docker-dind:${GOCD_VERSION}

LABEL description="GoCD agent based on docker version dind with compose" \
      maintainer="Volodymyr Mykhailyk. <volodymyr.mykhailyk@gmail.com>"

USER root
# Install compose
RUN apk add --update --no-cache \
    py-pip \
    python-dev \
    libffi-dev \
    openssl-dev \
    gcc \
    libc-dev \
    make \
    jq

ARG COMPOSE_VERSION=1.24.1
RUN pip install docker-compose==${COMPOSE_VERSION}

COPY --from=ecr-credentials /go/bin/docker-credential-ecr-login /usr/local/bin/docker-credential-ecr-login

USER go
