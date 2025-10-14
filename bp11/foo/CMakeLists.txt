add_library(foo)
target_sources(foo PRIVATE foo.hpp foo.cpp)
target_include_directories(foo
  PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:include>)
target_compile_features(foo PUBLIC cxx_std_17)
set_target_properties(foo PROPERTIES
  VERSION ${PROJECT_VERSION}
  PUBLIC_HEADER foo.hpp)
# note: macOS is APPLE and also UNIX !
if(APPLE)
  set_target_properties(foo PROPERTIES
    INSTALL_RPATH "@loader_path")
elseif(UNIX)
  set_target_properties(foo PROPERTIES
    INSTALL_RPATH "$ORIGIN")
endif()
#target_link_libraries(foo PUBLIC)
add_library(${PROJECT_NAMESPACE}::foo ALIAS foo)

add_cxx_test(
  NAME foo_test
  SOURCES foo_test.cpp
  LINK_LIBRARIES ${PROJECT_NAMESPACE}::foo
)

# Install
install(TARGETS foo
  EXPORT ${PROJECT_NAME}Targets
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/bp11/foo)
