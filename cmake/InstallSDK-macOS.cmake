if(APPLE)
    option(BUILD_UNIVERSAL_LIBS "Build universal macOS libraries using an SDK" OFF)
endif()
if(BUILD_UNIVERSAL_LIBS)
    set(CMAKE_OSX_DEPLOYMENT_TARGET 10.13 CACHE STRING "Universal macOS SDK Version" FORCE )
endif()

# macOS SDK Dependency
if (BUILD_UNIVERSAL_LIBS)
  set(MACOS_SDK_BASENAME MacOSX${CMAKE_OSX_DEPLOYMENT_TARGET}.sdk)
  set(MACOS_SDK_GIT_BRANCH ef9fe35)
  externalproject_add(
      osx-sdk
      URL https://github.com/phracker/MacOSX-SDKs/archive/${MACOS_SDK_GIT_BRANCH}.tar.gz
      URL_HASH SHA256=e68a61f1c1f5fcd3fd81c93505828523e60964d4086caed4ca3fe8e45254e7c4
      SOURCE_DIR osx-sdk-prefix/SDKs/
      DOWNLOAD_NO_PROGRESS true
      CONFIGURE_COMMAND ""
      BUILD_COMMAND ""
      INSTALL_COMMAND ""
      BUILD_IN_SOURCE true
  )
  list(APPEND GLOBAL_DEPENDS osx-sdk)

  # Get the SDK sysroot
  set(OSX_SDK_SYSROOT "${CMAKE_CURRENT_BINARY_DIR}/osx-sdk-prefix/")

  # Append the new CMake args
  list(APPEND GLOBAL_CMAKE_ARGS
      -DCMAKE_OSX_SYSROOT:PATH=${OSX_SDK_SYSROOT}/SDKs/${MACOS_SDK_BASENAME}/
      -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET}
  )

  # Setup the Boost arguments and files
  set(BOOST_OSX_SDK macosx-version=${CMAKE_OSX_DEPLOYMENT_TARGET} macosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET})
  configure_file(${PROJECT_SOURCE_DIR}/patches/boost-macOS-user-config.jam.in ${CMAKE_CURRENT_BINARY_DIR}/user-config.jam)
  set(BOOST_PATCH_CMD cp ${CMAKE_CURRENT_BINARY_DIR}/user-config.jam tools/build/src/)
endif(BUILD_UNIVERSAL_LIBS)
