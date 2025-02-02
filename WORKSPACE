workspace(name = "mizux_bp11")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository", "new_git_repository")

# Bazel Extensions
## Bazel Skylib rules.
git_repository(
    name = "bazel_skylib",
    tag = "1.7.1",
    remote = "https://github.com/bazelbuild/bazel-skylib.git",
)
load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
bazel_skylib_workspace()

## Bazel rules.
git_repository(
    name = "platforms",
    tag = "0.0.10",
    remote = "https://github.com/bazelbuild/platforms.git",
)

git_repository(
    name = "rules_cc",
    tag = "0.0.16",
    remote = "https://github.com/bazelbuild/rules_cc.git",
)

git_repository(
    name = "rules_python",
    tag = "0.34.0",
    remote = "https://github.com/bazelbuild/rules_python.git",
)

# Dependencies
## Python
load("@rules_python//python:repositories.bzl", "py_repositories")
py_repositories()

load("@rules_python//python:repositories.bzl", "python_register_multi_toolchains")
DEFAULT_PYTHON = "3.11"
python_register_multi_toolchains(
    name = "python",
    default_version = DEFAULT_PYTHON,
    python_versions = [
      "3.12",
      "3.11",
      "3.10",
      "3.9",
      "3.8"
    ],
    ignore_root_user_error=True,
)

## `pybind11_bazel`
git_repository(
    name = "pybind11_bazel",
    tag = "v2.13.6", # 2024/04/08
    patches = ["//patches:pybind11_bazel.patch"],
    patch_args = ["-p1"],
    remote = "https://github.com/pybind/pybind11_bazel.git",
)

new_git_repository(
    name = "pybind11",
    build_file = "@pybind11_bazel//:pybind11-BUILD.bazel",
    tag = "v2.13.6",
    remote = "https://github.com/pybind/pybind11.git",
)

## Testing
git_repository(
    name = "googletest",
    tag = "v1.14.0",
    remote = "https://github.com/google/googletest.git",
)
