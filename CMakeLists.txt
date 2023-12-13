cmake_minimum_required(VERSION 3.24 FATAL_ERROR)

project(vc-deps VERSION 1.8.0)

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/)

include(ExternalProject)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#### Options ####
option(BUILD_SHARED_LIBS "Build libraries as shared" OFF)

#### Setup output directory if not specified ####
if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/deps" CACHE PATH "Default Install Path" FORCE )
endif()

#### Global CMake arguments ####
set(GLOBAL_CMAKE_ARGS
    "-DBUILD_SHARED_LIBS:STRING=${BUILD_SHARED_LIBS}"
    "-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}"
    "-DCMAKE_INSTALL_RPATH:PATH=${CMAKE_INSTALL_PREFIX}/lib"
    "-DCMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH}"
    "-DCMAKE_CXX_STANDARD:STRING=${CMAKE_CXX_STANDARD}"
    "-DCMAKE_CXX_STANDARD_REQUIRED:BOOL=${CMAKE_CXX_STANDARD_REQUIRED}"
    "-DCMAKE_INSTALL_MESSAGE:STRING=${CMAKE_INSTALL_MESSAGE}"
)
set(GLOBAL_DEPENDS "")

#### Build dependencies with same release type as root project ####
if(CMAKE_BUILD_TYPE)
  list(APPEND GLOBAL_CMAKE_ARGS
    "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}"
  )
endif()

if(CMAKE_POSITION_INDEPENDENT_CODE)
  list(APPEND GLOBAL_CMAKE_ARGS
    "-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=${CMAKE_POSITION_INDEPENDENT_CODE}"
  )
endif()

#### Setup a legacy macOS build using an SDK ####
include(InstallSDK-macOS)

#### Required libs ####
# zlib
include(BuildZLIB)

# libtiff
include(BuildTIFF)

# Boost
include(BuildBoost)

# Eigen
include(BuildEigen)

# VTK
include(BuildVTK)

# OpenCV
include(BuildOpenCV)

# ITK
include(BuildITK)

# ACVD
include(BuildACVD)

# spdlog
include(BuildSpdlog)
