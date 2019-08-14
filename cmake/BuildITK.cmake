option(VCDEPS_BUILD_ITK "Build ITK" ON)
if(VCDEPS_BUILD_ITK)
externalproject_add(
    itk
    DEPENDS eigen zlib libtiff opencv ${GLOBAL_DEPENDS}
    URL https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.0.1/InsightToolkit-5.0.1.tar.gz
    URL_HASH SHA256=613b125cbf58481e8d1e36bdeacf7e21aba4b129b4e524b112f70c4d4e6d15a6
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DITK_USE_SYSTEM_TIFF:BOOL=ON
        -DITK_USE_SYSTEM_ZLIB:BOOL=ON
        -DModule_ITKVideoBridgeOpenCV:BOOL=ON
        -DBUILD_EXAMPLES:BOOL=OFF
)
else()
  find_package(ITK REQUIRED)
  add_custom_target(itk)
endif()
