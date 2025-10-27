option(VCDEPS_BUILD_OPENCV "Build OpenCV" ON)

if(VCDEPS_BUILD_PNG)
  set(OPENCV_BUILD_PNG OFF)
else()
  set(OPENCV_BUILD_PNG ON)
endif()

set(OPENCV_BUILD_DNN ON)
if(BUILD_MACOS_MULTIARCH)
  set(OPENCV_BUILD_DNN OFF)
endif()

if(VCDEPS_BUILD_OPENCV)
externalproject_add(
    opencv
    DEPENDS zlib libtiff libpng ${GLOBAL_DEPENDS}
    URL https://github.com/opencv/opencv/archive/refs/tags/4.12.0.tar.gz
    URL_HASH SHA512=8ac63ddd61e22cc0eaeafee4f30ae6e1cab05fc4929e2cea29070203b9ca8dfead12cc0fd7c4a87b65c1e20ec6b9ab4865a1b83fad33d114fc0708fdf107c51b
    DOWNLOAD_NO_PROGRESS true
    DOWNLOAD_EXTRACT_TIMESTAMP ON
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DWITH_VTK:BOOL=OFF
        -DWITH_CUDA:BOOL=OFF
        -DBUILD_TIFF:BOOL=OFF
        -DBUILD_PNG:BOOL=${OPENCV_BUILD_PNG}
        -DBUILD_ZLIB:BOOL=OFF
        -DBUILD_TESTS:BOOL=OFF
        -DBUILD_PERF_TESTS:BOOL=OFF
        -DBUILD_EXAMPLES:BOOL=OFF
        -DWITH_FFMPEG:BOOL=OFF
        -DWITH_EIGEN:BOOL=OFF
        -DWITH_OPENEXR:BOOL=OFF
        -DOBSENSOR_USE_ORBBEC_SDK:BOOL=OFF
        -DWITH_OBSENSOR:BOOL=OFF
        -DBUILD_opencv_dnn:BOOL=${OPENCV_BUILD_DNN}
        -DWITH_PROTOBUF:BOOL=${OPENCV_BUILD_DNN}
        -DBUILD_PROTOBUF:BOOL=${OPENCV_BUILD_DNN}
)
else()
  find_package(OpenCV 3 QUIET)
  if(NOT OpenCV_FOUND)
    find_package(OpenCV 4 REQUIRED)
  endif()
  add_custom_target(opencv)
endif()
