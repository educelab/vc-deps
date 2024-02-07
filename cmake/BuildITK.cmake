option(VCDEPS_BUILD_ITK "Build ITK" ON)
if(VCDEPS_BUILD_ITK)

# Patch GDCM bug on GCC 11
set(ITK_PATCH_CMD patch -p1 -i ${CMAKE_SOURCE_DIR}/patches/itk-5.2.0-fix-gdcm-gcc11.diff)

externalproject_add(
    itk
    DEPENDS eigen zlib libtiff opencv ${GLOBAL_DEPENDS}
    URL https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.4rc02/InsightToolkit-5.4rc02.tar.gz
    URL_HASH SHA512=01e36218182220bcd3ec8975243cd7c65cce751092b3a85a2f3bb94d5ba7c5e196effa4bb797c8bca3ec5e84c8feeae59157ef1410c7b9df8a974482bf64f284
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
