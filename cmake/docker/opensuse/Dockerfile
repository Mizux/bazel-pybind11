# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/r/opensuse/tumbleweed
FROM opensuse/tumbleweed AS env
# Install system build dependencies
ENV PATH=/usr/local/bin:$PATH
RUN zypper update -y \
&& zypper install -y git patch gcc gcc-c++ cmake \
&& zypper clean -a
ENV CC=gcc CXX=g++

# Install Python
RUN zypper update -y \
&& zypper install -y \
 python3 python3-devel python3-pip python3-wheel \
 python3-virtualenv python3-setuptools \
 python3-numpy python3-pandas \
&& zypper clean -a

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
RUN cmake --build build --target test -v

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
RUN python3 sample.py

FROM install_build AS install_test
RUN python3 sample.py
