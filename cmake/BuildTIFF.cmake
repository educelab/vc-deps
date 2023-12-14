option(VCDEPS_BUILD_TIFF "Build libtiff" ON)
if(VCDEPS_BUILD_TIFF)
externalproject_add(
    libtiff
    DEPENDS zlib ${GLOBAL_DEPENDS}
    URL https://gitlab.com/libtiff/libtiff/-/archive/3705f82b6483c7906cf08cd6b9dcdcd59c61d779/libtiff-3705f82b6483c7906cf08cd6b9dcdcd59c61d779.tar.gz
    URL_HASH SHA512=3f28ea3763380e730a3b3220d173b4519cf8c9d69e6312e1364599233e11cfa4707ebc98484a07e63ed24a7ab3ada53da397e160da0f8ebc78cb6045e61d693d
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
