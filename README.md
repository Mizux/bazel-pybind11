Github-CI:
[![Build Status][amd64_linux_status]][amd64_linux_link]
[![Build Status][amd64_macos_status]][amd64_macos_link]
[![Build Status][amd64_windows_status]][amd64_windows_link]
[![Build Status][amd64_docker_status]][amd64_docker_link]

[amd64_linux_status]: https://github.com/Mizux/bazel-pybind11/actions/workflows/amd64_linux.yml/badge.svg
[amd64_linux_link]: https://github.com/Mizux/bazel-pybind11/actions/workflows/amd64_linux.yml
[amd64_macos_status]: https://github.com/Mizux/bazel-pybind11/actions/workflows/amd64_macos.yml/badge.svg
[amd64_macos_link]: https://github.com/Mizux/bazel-pybind11/actions/workflows/amd64_macos.yml
[amd64_windows_status]: https://github.com/Mizux/bazel-pybind11/actions/workflows/amd64_windows.yml/badge.svg
[amd64_windows_link]: https://github.com/Mizux/bazel-pybind11/actions/workflows/amd64_windows.yml
[amd64_docker_status]: https://github.com/Mizux/bazel-pybind11/actions/workflows/amd64_docker.yml/badge.svg
[amd64_docker_link]: https://github.com/Mizux/bazel-pybind11/actions/workflows/amd64_docker.yml

# Introduction
<nav for="project"> |
<a href="#requirement">Requirement</a> |
<a href="#codemap">Codemap</a> |
<a href="#dependencies">Dependencies</a> |
<a href="#build">Build</a> |
<a href="ci/README.md">CI</a> |
<a href="#appendices">Appendices</a> |
<a href="#license">License</a> |
</nav>

Bazel C++ pybind11 sample with tests and GitHub CI support.

This project should run on GNU/Linux, MacOS and Windows.

## Requirement
You'll need:

* "Bazel >= 4.0".

## Codemap
The project layout is as follow:

* [WORKSPACE](WORKSPACE) Top-level for [Bazel](https://bazel.build) based build.

## Dependencies
To complexify a little, this Bazel project is composed of three libraries (`foo`, `bar` and `foobar`)
with the following dependencies:

```sh
foo:
bar:
foobar: foo bar
foobarapp: foobar
```

## Build
To build this example you should use:

* on UNIX:
  ```sh
  bazel build --cxxopt=-std=c++17 //...:all
  ```

* on Windows when using MSVC:
  ```sh
  bazel build --cxxopt="-std:c++17" //...:all
  ```

## Running Tests
To build this example you should use:

* on UNIX:
  ```sh
  bazel test --cxxopt=-std=c++17 //...:all
  ```

* on Windows when using MSVC:
  ```sh
  bazel test --cxxopt="-std:c++17" //...:all
  ```

## CI Setup
Please take a look at [.github/workflows](.github/workflows) to find the configuration file for each jobs.

To install *bazel* on each hosted runner, follow these links:
ref: https://docs.github.com/en/actions/using-github-hosted-runners/customizing-github-hosted-runners#installing-software-on-windows-runners

* Linux (Ubuntu latest LTS) -> `apt-get install bazel`<br>
  ref: https://docs.bazel.build/versions/main/install-ubuntu.html<br>
  (as of 06/2021 Ubuntu 20.04 LTS is still not supported according to the doc...)
* MacOS -> `brew install bazel`<br>
  ref: https://formulae.brew.sh/formula/bazel#default
* Windows -> `choco install bazel`<br>
  ref: https://community.chocolatey.org/packages/bazel/

## Appendices
Few links on the subject...

### Resources
Project layout:
* The Pitchfork Layout Revision 1 (cxx-pflR1)

Bazel:
* https://docs.bazel.build/versions

### Misc
Image has been generated using [plantuml](http://plantuml.com/):
```bash
plantuml -Tsvg docs/{file}.dot
```
So you can find the dot source files in [docs](docs).

## License
Apache 2. See the LICENSE file for details.

## Disclaimer
This is not an official Google product, it is just code that happens to be
owned by Google.

