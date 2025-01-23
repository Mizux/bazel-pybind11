# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/_/debian
FROM debian:latest AS env

# Install system build dependencies
RUN apt update -qq \
&& apt install -yq \
 git wget curl libssl-dev build-essential \
&& apt clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Bazel
RUN curl https://bazel.build/bazel-release.pub.gpg | apt-key add -
ARG TARGETARCH=amd64
RUN echo "deb [arch=$TARGETARCH] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
RUN apt update -qq \
&& apt install -yq bazel default-jdk \
&& apt clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Python
RUN apt update -qq \
&& apt install -yq \
 python3-dev python3-pip python3-venv \
&& apt clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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
