# Use latest Python3 module (3.18)
cmake_minimum_required(VERSION 3.18)

# Find Python 3
find_package(Python3 REQUIRED COMPONENTS Interpreter Development.Module)

# Find if the python module is available,
# otherwise install it (PACKAGE_NAME) to the Python3 user install directory.
# If CMake option FETCH_PYTHON_DEPS is OFF then issue a fatal error instead.
# e.g
# search_python_module(
#   NAME
#     mypy_protobuf
#   PACKAGE
#     mypy-protobuf
#   NO_VERSION
# )
function(search_python_module)
  set(options NO_VERSION)
  set(oneValueArgs NAME PACKAGE)
  set(multiValueArgs "")
  cmake_parse_arguments(MODULE
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )
  message(STATUS "Searching python module: \"${MODULE_NAME}\"")
  if(${MODULE_NO_VERSION})
    execute_process(
      COMMAND ${Python3_EXECUTABLE} -c "import ${MODULE_NAME}"
      RESULT_VARIABLE _RESULT
      ERROR_QUIET
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set(MODULE_VERSION "unknown")
  else()
    execute_process(
      COMMAND ${Python3_EXECUTABLE} -c "import ${MODULE_NAME}; print(${MODULE_NAME}.__version__)"
      RESULT_VARIABLE _RESULT
      OUTPUT_VARIABLE MODULE_VERSION
      ERROR_QUIET
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
  endif()
  if(${_RESULT} STREQUAL "0")
    message(STATUS "Found python module: \"${MODULE_NAME}\" (found version \"${MODULE_VERSION}\")")
  else()
    if(FETCH_PYTHON_DEPS)
      message(WARNING "Can't find python module: \"${MODULE_NAME}\", install it using pip...")
      execute_process(
        COMMAND ${Python3_EXECUTABLE} -m pip install --user ${MODULE_PACKAGE}
        OUTPUT_STRIP_TRAILING_WHITESPACE
        COMMAND_ERROR_IS_FATAL ANY
      )
    else()
      message(FATAL_ERROR "Can't find python module: \"${MODULE_NAME}\", please install it using your system package manager.")
    endif()
  endif()
endfunction()

# Find if a python builtin module is available.
# e.g
# search_python_internal_module(
#   NAME
#     mypy_protobuf
# )
function(search_python_internal_module)
  set(options "")
  set(oneValueArgs NAME)
  set(multiValueArgs "")
  cmake_parse_arguments(MODULE
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )
  message(STATUS "Searching python module: \"${MODULE_NAME}\"")
  execute_process(
    COMMAND ${Python3_EXECUTABLE} -c "import ${MODULE_NAME}"
    RESULT_VARIABLE _RESULT
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )
  if(${_RESULT} STREQUAL "0")
    message(STATUS "Found python internal module: \"${MODULE_NAME}\"")
  else()
    message(FATAL_ERROR "Can't find python internal module \"${MODULE_NAME}\", please install it using your system package manager.")
  endif()
endfunction()

#######################
##  PYTHON WRAPPERS  ##
#######################
set(PYTHON_PROJECT ${PROJECT_NAMESPACE})
message(STATUS "Python project: ${PYTHON_PROJECT}")
set(PYTHON_PROJECT_DIR ${PROJECT_BINARY_DIR}/python/${PYTHON_PROJECT})
message(STATUS "Python project build path: ${PYTHON_PROJECT_DIR}")

#######################
## Python Packaging  ##
#######################
#file(MAKE_DIRECTORY python/${PYTHON_PROJECT})
file(GENERATE OUTPUT ${PYTHON_PROJECT_DIR}/__init__.py CONTENT "__version__ = \"${PROJECT_VERSION}\"\n")
file(GENERATE OUTPUT ${PYTHON_PROJECT_DIR}/foo/__init__.py CONTENT "")
file(GENERATE OUTPUT ${PYTHON_PROJECT_DIR}/foo/python/__init__.py CONTENT "")

# Adds py.typed to make typed packages.
file(GENERATE OUTPUT ${PYTHON_PROJECT_DIR}/foo/py.typed CONTENT "")
file(GENERATE OUTPUT ${PYTHON_PROJECT_DIR}/foo/python/py.typed CONTENT "")

# setup.py.in contains cmake variable e.g. @PYTHON_PROJECT@ and
# generator expression e.g. $<TARGET_FILE_NAME:foo_pybind11>
configure_file(
  ${PROJECT_SOURCE_DIR}/python/setup.py.in
  ${PROJECT_BINARY_DIR}/python/setup.py.in
  @ONLY)
file(GENERATE
  OUTPUT ${PROJECT_BINARY_DIR}/python/setup.py
  INPUT ${PROJECT_BINARY_DIR}/python/setup.py.in)

#add_custom_command(
#  OUTPUT python/setup.py
#  DEPENDS ${PROJECT_BINARY_DIR}/python/setup.py
#  COMMAND ${CMAKE_COMMAND} -E copy setup.py setup.py
#  WORKING_DIRECTORY python)

add_custom_command(
  OUTPUT python/foo_timestamp
  COMMAND ${CMAKE_COMMAND} -E remove -f foo_timestamp
  COMMAND ${CMAKE_COMMAND} -E make_directory ${PYTHON_PROJECT}/.libs
  # Don't need to copy static lib on Windows.
  COMMAND ${CMAKE_COMMAND} -E
   $<IF:$<STREQUAL:$<TARGET_PROPERTY:foo,TYPE>,SHARED_LIBRARY>,copy,true>
   $<$<STREQUAL:$<TARGET_PROPERTY:foo,TYPE>,SHARED_LIBRARY>:$<TARGET_SONAME_FILE:foo>>
   ${PYTHON_PROJECT}/.libs
  COMMAND ${CMAKE_COMMAND} -E touch ${PROJECT_BINARY_DIR}/python/foo_timestamp
  MAIN_DEPENDENCY
    python/setup.py.in
  DEPENDS
    python/setup.py
    ${PROJECT_NAMESPACE}::foo
  WORKING_DIRECTORY python
  COMMAND_EXPAND_LISTS)

add_custom_command(
  OUTPUT python/foo_pybind11_timestamp
  COMMAND ${CMAKE_COMMAND} -E remove -f foo_pybind11_timestamp
  COMMAND ${CMAKE_COMMAND} -E copy
    $<TARGET_FILE:foo_pybind11> ${PYTHON_PROJECT}/foo/python
  COMMAND ${CMAKE_COMMAND} -E touch ${PROJECT_BINARY_DIR}/python/foo_pybind11_timestamp
  MAIN_DEPENDENCY
    python/setup.py.in
  DEPENDS
    foo_pybind11
  WORKING_DIRECTORY python
  COMMAND_EXPAND_LISTS)


# Generate Stub
if(GENERATE_PYTHON_STUB)
# Look for required python modules
search_python_module(
  NAME mypy
  PACKAGE mypy
  NO_VERSION)

find_program(
  stubgen_EXECUTABLE
  NAMES stubgen stubgen.exe
  REQUIRED
)
message(STATUS "Python: stubgen: ${stubgen_EXECUTABLE}")

add_custom_command(
  OUTPUT python/stub_timestamp
  COMMAND ${CMAKE_COMMAND} -E remove -f stub_timestamp
  COMMAND ${stubgen_EXECUTABLE} -p bp11.foo.python.pyfoo --output .
  COMMAND ${CMAKE_COMMAND} -E touch ${PROJECT_BINARY_DIR}/python/stub_timestamp
  MAIN_DEPENDENCY
    python/setup.py.in
  DEPENDS
    python/foo_timestamp
    python/foo_pybind11_timestamp
  WORKING_DIRECTORY python
  COMMAND_EXPAND_LISTS)
endif()

# Look for required python modules
search_python_module(
  NAME setuptools
  PACKAGE setuptools)
search_python_module(
  NAME wheel
  PACKAGE wheel)

add_custom_command(
  OUTPUT python/dist_timestamp
  COMMAND ${CMAKE_COMMAND} -E remove_directory dist
  #COMMAND ${Python3_EXECUTABLE} setup.py bdist_egg bdist_wheel
  COMMAND ${Python3_EXECUTABLE} setup.py bdist_wheel
  COMMAND ${CMAKE_COMMAND} -E touch ${PROJECT_BINARY_DIR}/python/dist_timestamp
  MAIN_DEPENDENCY
    python/setup.py.in
  DEPENDS
    python/setup.py
    python/foo_timestamp
    python/foo_pybind11_timestamp
    $<$<BOOL:${GENERATE_PYTHON_STUB}>:python/stub_timestamp>
  BYPRODUCTS
    python/${PYTHON_PROJECT}
    python/${PYTHON_PROJECT}.egg-info
    python/build
    python/dist
  WORKING_DIRECTORY python
  COMMAND_EXPAND_LISTS)

# Main Target
add_custom_target(python_package ALL
  DEPENDS
    python/dist_timestamp
  WORKING_DIRECTORY python)

###################
##  Python Test  ##
###################
if(BUILD_TESTING)
  search_python_module(NAME virtualenv PACKAGE virtualenv)
  # venv not working on github windows runners
  # search_python_internal_module(NAME venv)
  # Testing using a vitual environment
  set(VENV_EXECUTABLE ${Python3_EXECUTABLE} -m virtualenv)
  #set(VENV_EXECUTABLE ${Python3_EXECUTABLE} -m venv)
  set(VENV_DIR ${CMAKE_CURRENT_BINARY_DIR}/python/venv)
  if(WIN32)
    set(VENV_Python3_EXECUTABLE ${VENV_DIR}/Scripts/python.exe)
  else()
    set(VENV_Python3_EXECUTABLE ${VENV_DIR}/bin/python)
  endif()
  # make a virtualenv to install our python package in it
  add_custom_command(TARGET python_package POST_BUILD
    # Clean previous install otherwise pip install may do nothing
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${VENV_DIR}
    COMMAND ${VENV_EXECUTABLE} -p ${Python3_EXECUTABLE} ${VENV_DIR}
    #COMMAND ${VENV_EXECUTABLE} ${VENV_DIR}
    # Must NOT call it in a folder containing the setup.py otherwise pip call it
    # (i.e. "python setup.py bdist") while we want to consume the wheel package
    COMMAND ${VENV_Python3_EXECUTABLE} -m pip install
      --find-links=${CMAKE_CURRENT_BINARY_DIR}/python/dist ${PYTHON_PROJECT}
    BYPRODUCTS ${VENV_DIR}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Create venv and install ${PYTHON_PROJECT}"
    VERBATIM)
endif()

# add_python_test()
# CMake function to generate and build python test.
# Parameters:
#  the python filename
# e.g.:
# add_python_test(foo_test.py)
function(add_python_test FILE_NAME)
  message(STATUS "Configuring test ${FILE_NAME} ...")
  get_filename_component(EXAMPLE_NAME ${FILE_NAME} NAME_WE)

  if(BUILD_TESTING)
    add_test(
      NAME python_test_${EXAMPLE_NAME}
      COMMAND ${VENV_Python3_EXECUTABLE} ${FILE_NAME}
      WORKING_DIRECTORY ${VENV_DIR})
  endif()
  message(STATUS "Configuring test ${FILE_NAME} done")
endfunction()
