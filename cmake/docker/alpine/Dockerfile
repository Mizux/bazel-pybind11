# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/_/alpine
FROM alpine:edge AS env

# Install system build dependencies
ENV PATH=/usr/local/bin:$PATH
RUN apk add --no-cache git build-base linux-headers cmake

# Install Python
RUN apk add --no-cache \
 python3-dev py3-pip py3-wheel \
 py3-virtualenv

# Add the library src to our build env
FROM env AS devel
WORKDIR /home/project
COPY . .

FROM devel AS build
RUN cmake --version
RUN cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release
RUN cmake --build build --target all -v
RUN cmake --build build --target install -v

FROM build AS test
RUN CTEST_OUTPUT_ON_FAILURE=1 cmake --build build --target test -v

# Test install rules
FROM env AS install_env
COPY --from=build /home/project/build/python/dist/*.whl ./
RUN python3 -m pip install \
 --break-system-packages \
 --find-links=. \
 bp11*.whl

FROM install_env AS install_devel
WORKDIR /home/samples
COPY cmake/samples .

FROM install_devel AS install_build
RUN python3 -m compileall .

FROM install_build AS install_test
RUN python3 sample.py
