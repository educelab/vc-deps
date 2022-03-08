option(VCDEPS_BUILD_ITK "Build ITK" ON)
if(VCDEPS_BUILD_ITK)

# Patch GDCM bug on GCC 11
set(ITK_PATCH_CMD patch -p1 -i ${CMAKE_SOURCE_DIR}/patches/itk-5.2.0-fix-gdcm-gcc11.diff)

externalproject_add(
    itk
    DEPENDS eigen zlib libtiff opencv ${GLOBAL_DEPENDS}
    URL https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.2.1/InsightToolkit-5.2.1.tar.gz
    URL_HASH SHA512=6786e39cdf3d0c3a31abd1e23481e30f6dc9dac189ffe372dde3db688f2f57686a8beb321778327e1ff683ed844d41f1dee937b0ba542b2365e2195dfca398c7
    DOWNLOAD_NO_PROGRESS true
    PATCH_COMMAND ${ITK_PATCH_CMD}
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DITK_USE_SYSTEM_TIFF:BOOL=ON
        -DITK_USE_SYSTEM_ZLIB:BOOL=ON
        -DModule_ITKSmoothing:BOOL=ON
        -DBUILD_EXAMPLES:BOOL=OFF
)
else()
  find_package(ITK REQUIRED)
  add_custom_target(itk)
endif()
