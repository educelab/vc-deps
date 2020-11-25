option(VCDEPS_BUILD_TIFF "Build libtiff" ON)
if(VCDEPS_BUILD_TIFF)
externalproject_add(
    libtiff
    DEPENDS zlib ${GLOBAL_DEPENDS}
    URL https://gitlab.com/libtiff/libtiff/-/archive/c824479e4c21974cd934502aa186d18bb548db9e/libtiff-c824479e4c21974cd934502aa186d18bb548db9e.tar.gz
    URL_HASH SHA256=4eaf0668f6c8b3f0f35a2ee7f704c8a7b053eeed5db307b75a84b14cdc3ba965
    DOWNLOAD_NO_PROGRESS true
    PATCH_COMMAND patch -p1 -i ${CMAKE_SOURCE_DIR}/patches/libtiff-c824479e-private-deps.diff
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
