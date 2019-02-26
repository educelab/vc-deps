option(VCDEPS_BUILD_TIFF "Build libtiff" ON)
if(VCDEPS_BUILD_TIFF)
externalproject_add(
    libtiff
    DEPENDS zlib ${GLOBAL_DEPENDS}
    URL http://download.osgeo.org/libtiff/tiff-4.0.9.tar.gz
    URL_HASH SHA1=87d4543579176cc568668617c22baceccd568296
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -Dlzma:BOOL=OFF
        -Djbig:BOOL=OFF
)
else()
  find_package(TIFF REQUIRED)
  add_custom_target(libtiff)
endif()
