option(VCDEPS_BUILD_OPENCV "Build OpenCV" ON)
if(VCDEPS_BUILD_OPENCV)
externalproject_add(
    opencv
    DEPENDS eigen zlib libtiff ${GLOBAL_DEPENDS}
    URL https://github.com/opencv/opencv/archive/3.3.1.tar.gz
    URL_HASH SHA1=79dba99090a5c48308fe91db8336ec2931e06b57
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DWITH_VTK:BOOL=OFF
        -DWITH_CUDA:BOOL=OFF
        -DBUILD_TIFF:BOOL=OFF
        -DBUILD_ZLIB:BOOL=OFF
        -DBUILD_TESTS:BOOL=OFF
        -DWITH_FFMPEG:BOOL=OFF
)
else()
  find_package(OpenCV 3 REQUIRED)
  add_custom_target(opencv)
endif()
