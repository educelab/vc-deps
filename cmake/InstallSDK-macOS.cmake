if(APPLE)
    option(BUILD_UNIVERSAL_LIBS "Build universal macOS libraries using an SDK" OFF)
endif()
if(BUILD_UNIVERSAL_LIBS AND CMAKE_OSX_DEPLOYMENT_TARGET STREQUAL "")
    set(CMAKE_OSX_DEPLOYMENT_TARGET 10.13 CACHE STRING "Universal macOS SDK Version" FORCE)
endif()

# macOS SDK Dependency
if (BUILD_UNIVERSAL_LIBS)
  set(MACOS_SDK_BASENAME MacOSX${CMAKE_OSX_DEPLOYMENT_TARGET}.sdk)
  externalproject_add(
      osx-sdk
      URL https://github.com/phracker/MacOSX-SDKs/releases/download/11.3/${MACOS_SDK_BASENAME}.tar.xz
      SOURCE_DIR osx-sdk-prefix/SDKs/${MACOS_SDK_BASENAME}/
      DOWNLOAD_NO_PROGRESS true
      CONFIGURE_COMMAND ""
      BUILD_COMMAND ""
      INSTALL_COMMAND ""
      BUILD_IN_SOURCE true
  )
  list(APPEND GLOBAL_DEPENDS osx-sdk)

  # Get the SDK sysroot
  set(OSX_SDK_SYSROOT "${CMAKE_CURRENT_BINARY_DIR}/osx-sdk-prefix")
  set(CMAKE_OSX_SYSROOT ${OSX_SDK_SYSROOT}/SDKs/${MACOS_SDK_BASENAME}/ CACHE PATH "The product will be built against the headers and libraries located inside the indicated SDK." FORCE)

  # Append the new CMake args
  list(APPEND GLOBAL_CMAKE_ARGS
      -DCMAKE_OSX_SYSROOT:PATH=${OSX_SDK_SYSROOT}/SDKs/${MACOS_SDK_BASENAME}/
      -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET}
  )

  # Print the macOS SDK location for the user
  message(STATUS "Downloaded macOS SDK path: ${OSX_SDK_SYSROOT}/SDKs/${MACOS_SDK_BASENAME}")
  message(STATUS "Using macOS SDK: ${CMAKE_OSX_SYSROOT}")

  # Setup the Boost arguments and files
  set(BOOST_OSX_SDK "-mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET} -isysroot ${CMAKE_OSX_SYSROOT}/")
endif(BUILD_UNIVERSAL_LIBS)
