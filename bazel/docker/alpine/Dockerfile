# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/_/alpine
FROM alpine:edge AS env

# Install system build dependencies
ENV PATH=/usr/local/bin:$PATH
RUN apk add --no-cache git build-base linux-headers zlib-dev
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing bazel7

ENV JAVA_HOME=/usr/lib/jvm/default-jvm
ENV PATH=$JAVA_HOME/bin:$PATH

# Install Python
RUN apk add --no-cache openssl python3-dev py3-pip py3-wheel
RUN python3 -m pip install --break-system-package absl-py

FROM env AS devel
WORKDIR /home/project
COPY . .

FROM devel AS build
RUN bazel version
RUN bazel build \
 -c opt \
 --subcommands=pretty_print \
 --enable_bzlmod \
 ...

FROM build AS test
RUN bazel test \
 -c opt \
 --test_output=errors \
 --enable_bzlmod \
 ... \
 -- -//bp11/foo/python:foo_test -//pure_lib:mylib_test
