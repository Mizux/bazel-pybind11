# Check dependencies
set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
set(THREAD_PREFER_PTHREAD_FLAG TRUE)
find_package(Threads REQUIRED)

# Tell find_package() to try “Config” mode before “Module” mode if no mode was specified.
# This should avoid find_package() to first find our FindXXX.cmake modules if
# distro package already provide a CMake config file...
set(CMAKE_FIND_PACKAGE_PREFER_CONFIG TRUE)

if(BUILD_TESTING)
  if(NOT BUILD_googletest)
    find_package(googletest REQUIRED)
  endif()
  if(NOT TARGET GTest::gtest)
    message(FATAL_ERROR "Target GTest::gtest not available.")
  endif()
  if(NOT TARGET GTest::gtest_main)
    message(FATAL_ERROR "Target GTest::gtest_main not available.")
  endif()
endif()

# Check language Dependencies
if(NOT BUILD_pybind11)
  find_package(pybind11 REQUIRED)
endif()
