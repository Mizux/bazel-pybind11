# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/_/fedora
FROM fedora:latest AS env

# Install system build dependencies
ENV PATH=/usr/local/bin:$PATH
RUN dnf -y update \
&& dnf -y install \
 git wget \
 @development-tools \
 gcc-c++ zlib-devel \
 dnf-plugins-core which \
&& dnf clean all

# Install Bazelisk
RUN wget \
https://github.com/bazelbuild/bazelisk/releases/download/v1.23.0/bazelisk-linux-amd64 \
&& chmod +x bazelisk-linux-amd64 \
&& mv bazelisk-linux-amd64 /usr/local/bin/bazel

# Install Java
RUN dnf -y update \
&& dnf -y install java-11-openjdk java-11-openjdk-devel maven \
&& dnf clean all
ENV JAVA_HOME=/usr/lib/jvm/java-openjdk

# Install Python
RUN dnf -y update \
&& dnf -y install python3 python3-devel python3-pip \
&& dnf clean all

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
 ...
