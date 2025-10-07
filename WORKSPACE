workspace(name = "bazel-pybind11")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository", "new_git_repository")

################################################################################
#
# WORKSPACE is being deprecated in favor of the new Bzlmod dependency system.
# It will be removed at some point in the future.
#
################################################################################

# Bazel Extensions
## Needed for Abseil.
git_repository(
    name = "bazel_skylib",
    commit = "56a2abbaf131332835ab2721a258ea3c763a7178",
    #tag = "1.8.1",
    remote = "https://github.com/bazelbuild/bazel-skylib.git",
)
load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
bazel_skylib_workspace()

git_repository(
    name = "bazel_features",
    commit = "3f23ff44ff85416d96566bee8e407694cdb6f1f8",
    #tag = "v1.32.0",
    remote = "https://github.com/bazel-contrib/bazel_features.git",
)
load("@bazel_features//:deps.bzl", "bazel_features_deps")
bazel_features_deps()

## Bazel rules.
git_repository(
    name = "platforms",
    commit = "ab99943ab6bed53cff461a3afa99fc79d31e4351",
    #tag = "1.0.0",
    remote = "https://github.com/bazelbuild/platforms.git",
)

git_repository(
    name = "rules_cc",
    commit = "cbee84ad7f583049823f3d1497aab1264cf94f26",
    #tag = "0.1.4",
    remote = "https://github.com/bazelbuild/rules_cc.git",
)

git_repository(
    name = "rules_python",
    tag = "1.5.1",
    remote = "https://github.com/bazelbuild/rules_python.git",
)

load("@rules_python//python:repositories.bzl", "py_repositories")
py_repositories()

load("@rules_python//python:repositories.bzl", "python_register_multi_toolchains")
DEFAULT_PYTHON = "3.12"
python_register_multi_toolchains(
    name = "python",
    default_version = DEFAULT_PYTHON,
    python_versions = [
      "3.12",
      "3.11",
      "3.10",
      "3.9",
    ],
    ignore_root_user_error=True,
)

## `pybind11_bazel`
git_repository(
    name = "pybind11_bazel",
    commit = "2b6082a4d9d163a52299718113fa41e4b7978db5",
    #tag = "v2.13.6", # 2024/04/08
    patches = ["//patches:pybind11_bazel.patch"],
    patch_args = ["-p1"],
    remote = "https://github.com/pybind/pybind11_bazel.git",
)

## `pybind11`
# https://github.com/pybind/pybind11
new_git_repository(
    name = "pybind11",
    build_file = "@pybind11_bazel//:pybind11-BUILD.bazel",
    commit = "a2e59f0e7065404b44dfe92a28aca47ba1378dc4",
    #tag = "v2.13.6",
    remote = "https://github.com/pybind/pybind11.git",
)

## Abseil-cpp
git_repository(
    name = "abseil-cpp",
    commit = "987c57f325f7fa8472fa84e1f885f7534d391b0d",
    #tag = "20250814.0",
    remote = "https://github.com/abseil/abseil-cpp.git",
)

## Re2
git_repository(
    name = "re2",
    commit = "6dcd83d60f7944926bfd308cc13979fc53dd69ca",
    #tag = "2024-07-02",
    remote = "https://github.com/google/re2.git",
    #repo_mapping = {"@abseil-cpp": "@com_google_absl"},
)

# Testing
## Googletest
git_repository(
    name = "googletest",
    commit = "52eb8108c5bdec04579160ae17225d66034bd723",
    #tag = "v1.17.0",
    remote = "https://github.com/google/googletest.git",
)
