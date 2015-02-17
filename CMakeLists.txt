project(tscreen C)

cmake_minimum_required(VERSION 2.6)

set(APPLICATION_NAME ${PROJECT_NAME})

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/Modules)

# Version handling
include(Tscreen)

# Configurable compilation options
include(TscreenBuildOptions)

# Check for function and header prereqs
include(TscreenPlatformChecks)

# generate headers and related source files
configure_file(cmake/config.h.cmake "${CMAKE_BINARY_DIR}/config.h")

message("")
message("${APPLICATION_NAME} ${VERSION_STRING} ${CMAKE_BUILD_TYPE}")
add_subdirectory(src)
add_subdirectory(data)
add_subdirectory(doc)
message("")

#vim: ts=4 sw=4 noet ai cindent syntax=cmake
