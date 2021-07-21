option(VCDEPS_BUILD_OPENCV "Build OpenCV" ON)
if(VCDEPS_BUILD_OPENCV)
externalproject_add(
    opencv
    DEPENDS zlib libtiff ${GLOBAL_DEPENDS}
    URL https://github.com/opencv/opencv/archive/4.5.3.tar.gz
    URL_HASH SHA512=efd2214f29b1eb2e1ae55280f9fc2f64af7c2e91154264c43d0d4186dd5b8f81e86942dff612d08cd9eaa834421457fe765760181160168cd4c52839a0739758
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
  find_package(OpenCV 3 QUIET)
  if(NOT OpenCV_FOUND)
    find_package(OpenCV 4 REQUIRED)
  endif()
  add_custom_target(opencv)
endif()
