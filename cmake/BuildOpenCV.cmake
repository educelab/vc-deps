option(VCDEPS_BUILD_OPENCV "Build OpenCV" ON)
if(VCDEPS_BUILD_OPENCV)
externalproject_add(
    opencv
    DEPENDS zlib libtiff ${GLOBAL_DEPENDS}
    URL https://github.com/opencv/opencv/archive/4.8.1.tar.gz
    URL_HASH SHA512=b98d89b8e7b8ae8138bce00c5226816b761b53fbeb8f28ca516e08c5d130f216f9388a81785cd6684034530f768e097cbe12f19a9361f362b7d2048bfc427a65
    DOWNLOAD_NO_PROGRESS true
    DOWNLOAD_EXTRACT_TIMESTAMP ON
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DWITH_VTK:BOOL=OFF
        -DWITH_CUDA:BOOL=OFF
        -DBUILD_TIFF:BOOL=OFF
        -DBUILD_ZLIB:BOOL=OFF
        -DBUILD_TESTS:BOOL=OFF
        -DWITH_FFMPEG:BOOL=OFF
        -DWITH_EIGEN:BOOL=OFF
        -DWITH_OPENEXR:BOOL=OFF
)
else()
  find_package(OpenCV 3 QUIET)
  if(NOT OpenCV_FOUND)
    find_package(OpenCV 4 REQUIRED)
  endif()
  add_custom_target(opencv)
endif()
