# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/_/fedora
# Fedora 36 do not provide bazel5
# see: https://github.com/vbatts/copr-build-bazel/issues/18
FROM fedora:latest AS env
LABEL maintainer="mizux.dev@gmail.com"
# Install system build dependencies
ENV PATH=/usr/local/bin:$PATH
RUN dnf -y update \
&& dnf -y install git \
&& dnf -y groupinstall "Development Tools" \
&& dnf -y install gcc-c++ zlib-devel \
&& dnf -y install dnf-plugins-core \
&& dnf -y copr enable vbatts/bazel \
&& dnf -y install bazel4 \
&& dnf clean all

# Install Python
RUN dnf -y update \
&& dnf -y install python3 python3-devel python3-pip \
&& dnf clean all

FROM env AS devel
WORKDIR /home/project
COPY . .

FROM devel AS build
RUN bazel version
RUN bazel build -c opt --cxxopt=-std=c++17 ...

FROM build AS test
# bazel4 always use `#!/usr/bin/env python`
# bazel5 struggle to find any python[3] interpreter in PATH even if available
# i.e. @rules_python//python:autodetecting_toolchain is broken
RUN ln -s /usr/bin/python3 /usr/local/bin/python
RUN bazel test -c opt --cxxopt=-std=c++17 --test_output=errors ...
