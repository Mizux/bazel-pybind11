# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/_/almalinux
FROM almalinux:latest AS env

# Install system build dependencies
ENV PATH=/usr/local/bin:$PATH
RUN dnf -y update \
&& dnf -y install git wget zlib-devel gcc-toolset-13 \
&& dnf -y group install "Development Tools" \
&& dnf clean all \
&& rm -rf /var/cache/dnf

RUN echo "source /opt/rh/gcc-toolset-13/enable" >> /etc/bashrc
SHELL ["/bin/bash", "--login", "-c"]

# Install Bazelisk
RUN wget \
https://github.com/bazelbuild/bazelisk/releases/download/v1.23.0/bazelisk-linux-amd64 \
&& chmod +x bazelisk-linux-amd64 \
&& mv bazelisk-linux-amd64 /usr/local/bin/bazel

# Install Python
RUN dnf -y update \
&& dnf -y install python3-devel python3-pip \
&& dnf clean all \
&& rm -rf /var/cache/dnf

# Add the library src to our build env
FROM env AS devel
WORKDIR /home/project
COPY . .
RUN sed -i 's/\(DEFAULT_PYTHON =\) "3.[0-9]\+"/\1 "3.9"/' WORKSPACE

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
