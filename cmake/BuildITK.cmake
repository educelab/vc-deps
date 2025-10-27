option(VCDEPS_BUILD_ITK "Build ITK" ON)
if(VCDEPS_BUILD_ITK)

# Patch GDCM bug on GCC 11
# set(ITK_PATCH_CMD patch -p1 -i ${CMAKE_SOURCE_DIR}/patches/itk-5.2.0-fix-gdcm-gcc11.diff)

externalproject_add(
    itk
    DEPENDS eigen zlib libtiff opencv ${GLOBAL_DEPENDS}
    URL https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.4.4/InsightToolkit-5.4.4.tar.gz
    URL_HASH SHA512=98e01bbbe6f9d1d2634dc6bd957edd3aef7ba6f2c3fc1d3de9dd00be1b2cda90df959c86275b3c6a57f7945852970d7b4bbe8f82ea8114a89f9a92cca15e2638
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
