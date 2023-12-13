option(VCDEPS_BUILD_TIFF "Build libtiff" ON)
if(VCDEPS_BUILD_TIFF)
externalproject_add(
    libtiff
    DEPENDS zlib ${GLOBAL_DEPENDS}
    URL https://gitlab.com/libtiff/libtiff/-/archive/v4.6.0/libtiff-v4.6.0.tar.gz
    URL_HASH SHA512=ef2f1d424219d9e245069b7d23e78f5e817cf6ee516d46694915ab6c8909522166f84997513d20a702f4e52c3f18467813935b328fafa34bea5156dee00f66fa
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
