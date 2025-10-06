#!/usr/bin/env bash

# Build all the wheel artifacts for the platforms supported by manylinux2014 and
# export them to the specified location.
set -euxo pipefail

function assert_defined(){
  if [[ -z "${!1}" ]]; then
    >&2 echo "Variable '${1}' must be defined"
    exit 1
  fi
}

function usage() {
  local -r NAME=$(basename "$0")
  echo -e "$NAME - Build using a cross toolchain.

SYNOPSIS
\t$NAME [-h|--help] [build|test|all]

DESCRIPTION
\tBuild all wheel artifacts.

OPTIONS
\t-h --help: show this help text
\tbuild: build the project using each python (note: remove previous build dir)
\ttest: install each wheel in a venv then test it (note: don't build !)
\tall: build + test (default)

EXAMPLES
$0 build"
}

function contains_element() {
  # Look for the presence of an element in an array. Echoes '0' if found,
  # '1' otherwise.
  # Arguments:
  #   $1 the element to be searched
  #   $2 the array to search into
  local e match="$1"
  shift
  for e; do
    [[ "$e" == "$match" ]] && return 0
  done
  return 1
}

function build_wheel() {
  assert_defined BUILD_DIR
  assert_defined VENV_DIR
  # Build the wheel artifact
  # Arguments:
  #   $1 the python root directory
  if [[ "$#" -ne 1 ]]; then
    echo "$0 called with an illegal number of parameters"
    exit 1
  fi

  # Create and activate virtualenv
  # this is needed so protoc can call the correct python executable
  local -r PYBIN="$1/bin"
  "${PYBIN}/pip" install virtualenv
  "${PYBIN}/virtualenv" -p "${PYBIN}/python" "${VENV_DIR}"
  # shellcheck source=/dev/null
  source "${VENV_DIR}/bin/activate"
  pip install -U pip setuptools wheel mypy

  echo "current dir: $(pwd)"

  if [[ ! -e "CMakeLists.txt" ]] || [[ ! -d "cmake" ]]; then
    >&2 echo "Can't find project's CMakeLists.txt or cmake"
    exit 2
  fi
  cmake -S. -B"${BUILD_DIR}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DPython3_ROOT_DIR="$1" \
    -DBUILD_TESTING=OFF #--debug-find
  cmake --build "${BUILD_DIR}" -v -j4

  # Restore environment
  deactivate
}

function check_wheel() {
  assert_defined BUILD_DIR
  assert_defined VENV_DIR
  # Check the wheel artifact
  # Arguments:
  #   $1 the python root directory
  if [[ "$#" -ne 1 ]]; then
    echo "$0 called with an illegal number of parameters"
    exit 1
  fi

  # shellcheck source=/dev/null
  source "${VENV_DIR}/bin/activate"
  pip install -U auditwheel

  # Check all generated wheel packages
  ROOT_DIR=$(pwd)
  pushd "${BUILD_DIR}/python/dist"
  for FILE in *.whl; do
    # if no files found do nothing
    [[ -e "$FILE" ]] || continue
    python -m auditwheel show "$FILE" || true
    python -m auditwheel repair --plat "manylinux_2_28_x86_64" "$FILE" -w .
    #python -m auditwheel -v repair --plat manylinux_2_28_x86_64 "$FILE" -w .
  done
  popd

  # Restore environment
  deactivate
}

function test_wheel() {
  assert_defined BUILD_DIR
  assert_defined TEST_DIR
  # Test the wheel artifacts
  # Arguments:
  #   $1 the python root directory
  if [[ "$#" -ne 1 ]]; then
    echo "$0 called with an illegal number of parameters"
    exit 1
  fi

  # Create and activate virtualenv
  local -r PYBIN="$1/bin"
  "${PYBIN}/pip" install virtualenv
  "${PYBIN}/virtualenv" -p "${PYBIN}/python" "${TEST_DIR}"

  # shellcheck source=/dev/null
  source "${TEST_DIR}/bin/activate"
  pip install -U pip setuptools wheel

  # Install the wheel artifact
  #pwd
  local -r WHEEL_FILE=$(find "${BUILD_DIR}"/python/dist/*.whl | head -1)
  echo "WHEEL file: ${WHEEL_FILE}"
  pip install --no-cache-dir "$WHEEL_FILE"
  pip show bp11

  # Python scripts to be used as tests for the installed wheel. This list of files
  # has been taken from the 'test_python' make target.
  declare -a TESTS=(
    "samples/sample.py"
    "tests/test.py"
  )

  # Run all the specified test scripts using the current environment.
  local -r ROOT_DIR=$(pwd)
  pushd "$(mktemp -d)" # ensure we are not importing something from $PWD
  python --version
  for TEST in "${TESTS[@]}"; do
    python "${ROOT_DIR}/${TEST}"
  done
  popd

  # Restore environment
  deactivate
}

function build() {
  # For each python platform provided by manylinux, build and test artifacts.
  for PYROOT in /opt/python/cp*; do
    # shellcheck disable=SC2155
    PYTAG=$(basename "$PYROOT")
    echo "Python: $PYTAG"

    # Check for platforms to be skipped
    if contains_element "$PYTAG" "${SKIPS[@]}"; then
      >&2 echo "skipping deprecated platform $PYTAG"
      continue
    fi

    BUILD_DIR="build_${PYTAG}"
    VENV_DIR="env_${PYTAG}"
    build_wheel "$PYROOT"
    check_wheel "$PYROOT"
  done
}

function tests() {
  # For each python platform provided by manylinux, build and test artifacts.
  for PYROOT in /opt/python/cp*; do
    # shellcheck disable=SC2155
    PYTAG=$(basename "$PYROOT")
    echo "Python: $PYTAG"

    # Check for platforms to be skipped
    if contains_element "$PYTAG" "${SKIPS[@]}"; then
      >&2 echo "skipping deprecated platform $PYTAG"
      continue
    fi

    BUILD_DIR="build_${PYTAG}"
    TEST_DIR="test_${PYTAG}"
    test_wheel "$PYROOT"
  done
}

# Main
function main() {
  case ${1} in
    -h | --help)
      usage; exit ;;
  esac

  # Setup
  declare -a SKIPS=("cp36-cp36m" "cp37-cp37m")

  case ${1} in
    build)
      build ;;
    test)
      tests ;;
    *)
      build
      tests ;;
  esac
}

main "${1:-all}"
