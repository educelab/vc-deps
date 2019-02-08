if(APPLE)
    option(BUILD_UNIVERSAL_LIBS "Build universal macOS libraries using an SDK" OFF)
endif()
if(BUILD_UNIVERSAL_LIBS)
    set(CMAKE_OSX_DEPLOYMENT_TARGET 10.9 CACHE STRING "Universal macOS SDK Version" FORCE )
endif()

# macOS SDK Dependency
if (BUILD_UNIVERSAL_LIBS)
  set(MACOS_SDK_BASENAME MacOSX${CMAKE_OSX_DEPLOYMENT_TARGET}.sdk)
  externalproject_add(
      osx-sdk
      URL https://github.com/phracker/MacOSX-SDKs/releases/download/10.13/${MACOS_SDK_BASENAME}.tar.xz
      URL_HASH SHA1=f35ad1305939fcf14bb1fac036efb2b0c31ebd12
      DOWNLOAD_NO_PROGRESS true
      CONFIGURE_COMMAND mkdir -p SDKs/${MACOS_SDK_BASENAME}
      BUILD_COMMAND mv System SDKs/${MACOS_SDK_BASENAME}/ &&
          mv usr SDKs/${MACOS_SDK_BASENAME}/ &&
          mv SDKSettings.plist SDKs/${MACOS_SDK_BASENAME}/
      INSTALL_COMMAND ""
      BUILD_IN_SOURCE true
  )
  list(APPEND GLOBAL_DEPENDS osx-sdk)

  # Get the SDK sysroot
  ExternalProject_Get_property(osx-sdk SOURCE_DIR)
  set(OSX_SDK_SYSROOT ${SOURCE_DIR})

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
