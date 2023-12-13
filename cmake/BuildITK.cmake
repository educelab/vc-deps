option(VCDEPS_BUILD_ITK "Build ITK" ON)
if(VCDEPS_BUILD_ITK)

# Patch GDCM bug on GCC 11
set(ITK_PATCH_CMD patch -p1 -i ${CMAKE_SOURCE_DIR}/patches/itk-5.2.0-fix-gdcm-gcc11.diff)

externalproject_add(
    itk
    DEPENDS eigen zlib libtiff opencv ${GLOBAL_DEPENDS}
    URL https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.3.0/InsightToolkit-5.3.0.tar.gz
    URL_HASH SHA512=29359839c0fb13acd430410e6adadbecb4d9d8cb4871a0aba0ac67b539c235354a591655dd654f43daa5f035a33721671d665eee8a4a129a9d0d3419e2356e97
    DOWNLOAD_NO_PROGRESS true
    DOWNLOAD_EXTRACT_TIMESTAMP ON
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
