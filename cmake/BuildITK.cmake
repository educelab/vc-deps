option(VCDEPS_BUILD_ITK "Build ITK" ON)
if(VCDEPS_BUILD_ITK)
externalproject_add(
    itk
    DEPENDS zlib libtiff opencv ${GLOBAL_DEPENDS}
    URL https://downloads.sourceforge.net/project/itk/itk/4.12/InsightToolkit-4.12.2.tar.gz
    URL_HASH SHA1=8733dab485b2df860bc5808f7f2351773b293feb
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
