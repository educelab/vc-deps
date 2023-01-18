option(VCDEPS_BUILD_OPENCV "Build OpenCV" ON)
if(VCDEPS_BUILD_OPENCV)
externalproject_add(
    opencv
    DEPENDS zlib libtiff ${GLOBAL_DEPENDS}
    URL https://github.com/opencv/opencv/archive/4.5.5.tar.gz
    URL_HASH SHA512=4d1783fd78425cc43bb2153446dd634cedd366a49592bccc0c538a40aa161fcf67db8f1b6b68f1ce0b4a93504b3f06f65931709277afb1a1ee9fe963094bca02
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
        -DWITH_OPENEXR:BOOL=OFF
)
else()
  find_package(OpenCV 3 QUIET)
  if(NOT OpenCV_FOUND)
    find_package(OpenCV 4 REQUIRED)
  endif()
  add_custom_target(opencv)
endif()
