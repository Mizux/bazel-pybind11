add_cxx_library(
  NAME
    foo
  HEADERS
    foo.h
  SOURCES
    foo.cc
  INSTALL_DIR
    bp11/foo
)

add_cxx_test(
  NAME foo_test
  SOURCES foo_test.cc
  LINK_LIBRARIES ${PROJECT_NAMESPACE}::foo
)
