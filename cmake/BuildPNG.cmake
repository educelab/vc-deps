option(VCDEPS_BUILD_PNG "Build libpng" ${BUILD_MACOS_MULTIARCH})

if(VCDEPS_BUILD_PNG)

set(PNG_SHARED ${BUILD_SHARED_LIBS})
if(NOT PNG_SHARED)
  set(PNG_STATIC ON)
else()
  set(PNG_STATIC OFF)
endif()

externalproject_add(
    libpng
    DEPENDS zlib ${GLOBAL_DEPENDS}
    GIT_REPOSITORY https://github.com/csparker247/libpng.git
    GIT_TAG cmake-fix-macos-universal
    DOWNLOAD_NO_PROGRESS true
    DOWNLOAD_EXTRACT_TIMESTAMP ON
    PATCH_COMMAND ${PNG_PATCH_CMD}
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DPNG_TESTS:BOOL=OFF
        -DPNG_TOOLS:BOOL=ON
        -DPNG_FRAMEWORK:BOOL=OFF
        -DPNG_SHARED:BOOL=${PNG_SHARED}
        -DPNG_STATIC:BOOL=${PNG_STATIC}
)
else()
  # Nothing to do. OpenCV will build it.
  add_custom_target(libpng)
endif()
