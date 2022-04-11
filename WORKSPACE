workspace(name = "org_mizux_bazelpybind11")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository", "new_git_repository")

git_repository(
    name = "com_google_googletest",
    tag = "release-1.11.0",
    remote = "https://github.com/google/googletest.git",
)

# Python
git_repository(
    name = "rules_python",
    tag = "0.8.0",
    remote = "https://github.com/bazelbuild/rules_python.git",
)

git_repository(
    name = "pybind11_bazel",
    commit = "72cbbf1fbc830e487e3012862b7b720001b70672",
    remote = "https://github.com/pybind/pybind11_bazel.git",
)

new_git_repository(
    name = "pybind11",
    build_file = "@pybind11_bazel//:pybind11.BUILD",
    tag = "v2.9.1",
    remote = "https://github.com/pybind/pybind11.git",
)

load("@pybind11_bazel//:python_configure.bzl", "python_configure")
python_configure(name = "local_config_python", python_version = "3")
