Github-CI:
| OS      | Bazel | CMake |
|:------- | :---: | :---: |
| Linux   | [![Build Status][amd64_linux_bazel_status]][amd64_linux_bazel_link] | [![Build Status][amd64_linux_cmake_status]][amd64_linux_cmake_link] |
| MacOS   | [![Build Status][amd64_macos_bazel_status]][amd64_macos_bazel_link] | [![Build Status][amd64_macos_cmake_status]][amd64_macos_cmake_link] |
| Windows | [![Build Status][amd64_windows_bazel_status]][amd64_windows_bazel_link] | [![Build Status][amd64_windows_cmake_status]][amd64_windows_cmake_link] |
| Docker  | [![Build Status][amd64_docker_bazel_status]][amd64_docker_bazel_link] | [![Build Status][amd64_docker_cmake_status]][amd64_docker_cmake_link] |

[amd64_linux_bazel_status]: ./../../actions/workflows/amd64_linux_bazel.yml/badge.svg
[amd64_linux_bazel_link]: ./../../actions/workflows/amd64_linux_bazel.yml
[amd64_macos_bazel_status]: ./../../actions/workflows/amd64_macos_bazel.yml/badge.svg
[amd64_macos_bazel_link]: ./../../actions/workflows/amd64_macos_bazel.yml
[amd64_windows_bazel_status]: ./../../actions/workflows/amd64_windows_bazel.yml/badge.svg
[amd64_windows_bazel_link]: ./../../actions/workflows/amd64_windows_bazel.yml
[amd64_docker_bazel_status]: ./../../actions/workflows/amd64_docker_bazel.yml/badge.svg
[amd64_docker_bazel_link]: ./../../actions/workflows/amd64_docker_bazel.yml

[amd64_linux_cmake_status]: ./../../actions/workflows/amd64_linux_cmake.yml/badge.svg
[amd64_linux_cmake_link]: ./../../actions/workflows/amd64_linux_cmake.yml
[amd64_macos_cmake_status]: ./../../actions/workflows/amd64_macos_cmake.yml/badge.svg
[amd64_macos_cmake_link]: ./../../actions/workflows/amd64_macos_cmake.yml
[amd64_windows_cmake_status]: ./../../actions/workflows/amd64_windows_cmake.yml/badge.svg
[amd64_windows_cmake_link]: ./../../actions/workflows/amd64_windows_cmake.yml
[amd64_docker_cmake_status]: ./../../actions/workflows/amd64_docker_cmake.yml/badge.svg
[amd64_docker_cmake_link]: ./../../actions/workflows/amd64_docker_cmake.yml

# Introduction

<nav for="project"> |
<a href="#requirement">Requirement</a> |
<a href="#codemap">Codemap</a> |
<a href="#dependencies">Dependencies</a> |
<a href="#build">Build</a> |
<a href="bazel/README.md">Bazel CI</a> |
<a href="cmake/README.md">CMake CI</a> |
<a href="#appendices">Appendices</a> |
<a href="#license">License</a> |
</nav>

Bazel C++ and pybind11 sample with tests and GitHub CI support.<br>
This project should run on GNU/Linux, MacOS and Windows.

note: A CMake support is also provided as comparison

## Requirement

You'll need:

* "Bazel >= 6.0".
* "CMake >= 3.25".

## Codemap

The project layout is as follow:

* [WORKSPACE](WORKSPACE) Top-level for [Bazel](https://bazel.build) based build.
* [pure_lib](pure_lib) Pure python library to check Python support.
* [native_lib](native_lib) Simple C++ library.
  * [python](native_lib/python) Python wrapper using pybind11.

## Build

To build this example you should use:

* on UNIX:

  ```sh
  bazel build -c opt --action_env=BAZEL_CXXOPTS="-std=c++17" --subcommands=true ...
  ```

* on Windows when using MSVC:

  ```sh
  bazel build -c opt --cxxopt="/std:c++17" --subcommands=true ...
  ```

## Running Tests

To build this example you should use:

* on UNIX:

  ```sh
  bazel test -c opt --action_env=BAZEL_CXXOPTS="-std=c++17" --test_output=all ...
  ```

* on Windows when using MSVC:

  ```sh
  bazel test -c opt --cxxopt="/std:c++17" --test_output=all ...
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
