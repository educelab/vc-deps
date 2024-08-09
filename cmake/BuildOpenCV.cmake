option(VCDEPS_BUILD_OPENCV "Build OpenCV" ON)
if(VCDEPS_BUILD_OPENCV)
externalproject_add(
    opencv
    DEPENDS zlib libtiff libpng ${GLOBAL_DEPENDS}
    URL https://github.com/opencv/opencv/archive/4.10.0.tar.gz
    URL_HASH SHA512=b4f7248f89f1cd146dbbae7860a17131cd29bd3cb81db1e678abfcfbf2d8fa4a7633bfd0edbf50afae7b838c8700e8c0d0bb05828139d5cb5662df6bbf3eb92c
    DOWNLOAD_NO_PROGRESS true
    DOWNLOAD_EXTRACT_TIMESTAMP ON
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DWITH_VTK:BOOL=OFF
        -DWITH_CUDA:BOOL=OFF
        -DBUILD_TIFF:BOOL=OFF
        -DBUILD_PNG:BOOL=OFF
        -DBUILD_ZLIB:BOOL=OFF
        -DBUILD_TESTS:BOOL=OFF
        -DWITH_FFMPEG:BOOL=OFF
        -DWITH_EIGEN:BOOL=OFF
        -DWITH_OPENEXR:BOOL=OFF
        -DOBSENSOR_USE_ORBBEC_SDK:BOOL=OFF
        -DWITH_OBSENSOR:BOOL=OFF
        -DOPENCV_DNN_OPENCL:BOOL=OFF
        -DWITH_PROTOBUF:BOOL=OFF
        -DBUILD_PROTOBUF:BOOL=OFF
)
else()
  find_package(OpenCV 3 QUIET)
  if(NOT OpenCV_FOUND)
    find_package(OpenCV 4 REQUIRED)
  endif()
  add_custom_target(opencv)
endif()
