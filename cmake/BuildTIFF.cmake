option(VCDEPS_BUILD_TIFF "Build libtiff" ON)
if(VCDEPS_BUILD_TIFF)
externalproject_add(
    libtiff
    DEPENDS zlib ${GLOBAL_DEPENDS}
    GIT_REPOSITORY https://gitlab.com/libtiff/libtiff.git
    GIT_TAG origin/cmake-cmath-avoid-imported-target
    DOWNLOAD_NO_PROGRESS true
    DOWNLOAD_EXTRACT_TIMESTAMP ON
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -Dlzma:BOOL=OFF
        -Djbig:BOOL=OFF
        -Djpeg:BOOL=OFF
        -Dwebp:BOOL=OFF
        -Dzstd:BOOL=OFF
)
else()
  find_package(TIFF REQUIRED)
  add_custom_target(libtiff)
endif()
