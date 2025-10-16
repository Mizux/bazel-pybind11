include(FetchContent)
set(FETCHCONTENT_QUIET OFF)
set(FETCHCONTENT_UPDATES_DISCONNECTED ON)
set(BUILD_SHARED_LIBS ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(BUILD_TESTING OFF)
set(CMAKE_Fortran_COMPILER OFF)

# ##############################################################################
# ABSEIL-CPP
# ##############################################################################
if(BUILD_absl)
  message(CHECK_START "Fetching Abseil-cpp")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")
  FetchContent_Declare(
    absl
    GIT_REPOSITORY "https://github.com/abseil/abseil-cpp.git"
    GIT_TAG "20250814.1"
    GIT_SHALLOW TRUE
    UPDATE_COMMAND git reset --hard
    PATCH_COMMAND git apply --ignore-whitespace
    "${CMAKE_CURRENT_LIST_DIR}/../../patches/abseil-cpp-20250814.1.patch"
    OVERRIDE_FIND_PACKAGE
  )
  set(ABSL_USE_SYSTEM_INCLUDES ON)
  # We want Abseil to declare what C++ standard it was compiled with.
  set(ABSL_PROPAGATE_CXX_STD ON)
  # We want Abseil to keep the INSTALL rules enabled, even though it is a
  # subproject. Otherwise the install rules in this project break.
  set(ABSL_ENABLE_INSTALL ON)
  set(ABSL_BUILD_TESTING OFF)
  set(ABSL_BUILD_TEST_HELPERS OFF)
  set(ABSL_USE_EXTERNAL_GOOGLETEST ON)
  set(ABSL_FIND_GOOGLETEST OFF)
  FetchContent_MakeAvailable(absl)
  list(POP_BACK CMAKE_MESSAGE_INDENT)
  message(CHECK_PASS "fetched")
endif()

# ##############################################################################
# RE2
# ##############################################################################
if(BUILD_re2)
  message(CHECK_START "Fetching re2")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")
  FetchContent_Declare(
    re2
    GIT_REPOSITORY "https://github.com/google/re2.git"
    GIT_TAG "2025-08-12"
    GIT_SHALLOW TRUE
    UPDATE_COMMAND git reset --hard
    PATCH_COMMAND git apply --ignore-whitespace
    "${CMAKE_CURRENT_LIST_DIR}/../../patches/re2-2025-08-12.patch"
  )
  set(RE2_BUILD_TESTING OFF)
  FetchContent_MakeAvailable(re2)
  list(POP_BACK CMAKE_MESSAGE_INDENT)
  message(CHECK_PASS "fetched")
endif()

# ##############################################################################
# pybind11
# ##############################################################################
# Find Python 3
find_package(Python3 REQUIRED COMPONENTS Interpreter Development.Module)
message(STATUS "Python: ${Python3_EXECUTABLE}")

if(BUILD_pybind11)
  message(CHECK_START "Fetching pybind11")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")
  FetchContent_Declare(
    pybind11
    GIT_REPOSITORY "https://github.com/pybind/pybind11.git"
    GIT_TAG "v3.0.0"
    GIT_SHALLOW TRUE
    #UPDATE_COMMAND git reset --hard
    #PATCH_COMMAND git apply --ignore-whitespace
    # "${CMAKE_CURRENT_LIST_DIR}/../../patches/pybind11-v3.0.0.patch"
  )
  set(PYBIND11_FINDPYTHON ON)
  set(PYBIND11_INSTALL ON)
  set(PYBIND11_TEST OFF)
  FetchContent_MakeAvailable(pybind11)
  list(POP_BACK CMAKE_MESSAGE_INDENT)
  message(CHECK_PASS "fetched")
endif()

###############
##  TESTING  ##
###############
if(BUILD_googletest)
  message(CHECK_START "Fetching googletest")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")
  FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG v1.17.0
    GIT_SHALLOW TRUE
    UPDATE_COMMAND git reset --hard
    PATCH_COMMAND git apply --ignore-whitespace
    "${CMAKE_CURRENT_LIST_DIR}/../../patches/googletest-v1.17.0.patch"
  )
  set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
  set(GTEST_HAS_ABSL ON)
  set(INSTALL_GTEST OFF)
  FetchContent_MakeAvailable(googletest)
  list(POP_BACK CMAKE_MESSAGE_INDENT)
  message(CHECK_PASS "fetched")
endif()
