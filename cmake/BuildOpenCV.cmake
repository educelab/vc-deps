option(VCDEPS_BUILD_OPENCV "Build OpenCV" ON)
if(VCDEPS_BUILD_OPENCV)
externalproject_add(
    opencv
    DEPENDS zlib libtiff ${GLOBAL_DEPENDS}
    URL https://github.com/opencv/opencv/archive/3.4.7.tar.gz
    URL_HASH SHA256=ea743896a604a6ba1e1c1651ad42c97d0f90165debe9940811c7e0bdaa307526
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DWITH_VTK:BOOL=OFF
        -DWITH_CUDA:BOOL=OFF
        -DBUILD_TIFF:BOOL=OFF
        -DBUILD_ZLIB:BOOL=OFF
        -DBUILD_TESTS:BOOL=OFF
        -DWITH_FFMPEG:BOOL=OFF
        -DWITH_EIGEN:BOOL=OFF
)
else()
  find_package(OpenCV 3 REQUIRED)
  add_custom_target(opencv)
endif()
