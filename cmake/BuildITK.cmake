option(VCDEPS_BUILD_ITK "Build ITK" ON)
if(VCDEPS_BUILD_ITK)

# Patch GDCM bug on GCC 11
set(ITK_PATCH_CMD patch -p1 -i ${CMAKE_SOURCE_DIR}/patches/itk-5.2.0-fix-gdcm-gcc11.diff)

externalproject_add(
    itk
    DEPENDS eigen zlib libtiff opencv ${GLOBAL_DEPENDS}
    URL https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.2.0/InsightToolkit-5.2.0.tar.gz
    URL_HASH SHA512=57706eff872cd80d8b3edfb59ee99a9c4b56f35009dcef63d91e6bd61817a6be432e27ed29a8eab12748a4942ed12a8129e7a95ac98fe1beefea2ed3a19083bf
    DOWNLOAD_NO_PROGRESS true
    PATCH_COMMAND ${ITK_PATCH_CMD}
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
