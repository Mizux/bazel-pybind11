# CI: Makefile/Docker testing

To test the build on various distro, I'm using docker containers and a Makefile for orchestration.

pros:
* You are independent of third party CI runner VM images (e.g. [github actions/virtual-environments](https://github.com/actions/virtual-environments)).
* You can run it locally on any host having a linux docker image support.
* Most CI provide runner with docker and Makefile installed.

cons:

* Only GNU/Linux distro supported.
* Could take few GiB.

## Usage

To get the help simply type:

```sh
make
```

note: you can also use from top directory

```sh
make --directory=ci
```

### Example

For example to test inside an `Alpine` container:

```sh
make alpine_test
```

## Docker Layers

Dockerfile is splitted in several stages.

![docker](docs/docker.svg)

## Docker aarch64 on x86_64 machine

You can build and run aarch64 docker container on a x86_64 by enabling qemu
support:

```sh
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

ref: https://github.com/multiarch/qemu-user-static#getting-started
