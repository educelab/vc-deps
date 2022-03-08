option(VCDEPS_BUILD_TIFF "Build libtiff" ON)
if(VCDEPS_BUILD_TIFF)
externalproject_add(
    libtiff
    DEPENDS zlib ${GLOBAL_DEPENDS}
    URL https://gitlab.com/libtiff/libtiff/-/archive/5e18004500cda10d9074bdb6166b054e95b659ed/libtiff-5e18004500cda10d9074bdb6166b054e95b659ed.tar.gz
    URL_HASH SHA512=cf19fbfcc278fe9d113035db0aa4df56f461ba311394c40d43dd5da9f9a3e4a399acf885c57c3511e16cc396a90db0965e99440cebc40f45ac1e404e59196d08
    DOWNLOAD_NO_PROGRESS true
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
