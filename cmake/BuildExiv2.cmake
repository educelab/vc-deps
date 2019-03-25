option(VCDEPS_BUILD_EXIV2 "Build exiv2" ON)
if(VCDEPS_BUILD_EXIV2)
find_package(Intl QUIET)
externalproject_add(
    exiv2
    DEPENDS ${GLOBAL_DEPENDS} zlib
    URL https://github.com/Exiv2/exiv2/archive/5118c64.tar.gz
    URL_HASH SHA256=1be6b11120d0d049cace4e77e625a0e806dadd3fabf90cc4841dde37f23f37ca
    DOWNLOAD_NO_PROGRESS true
    PATCH_COMMAND patch -p1 -i ${CMAKE_SOURCE_DIR}/patches/exiv2-5118c64-cmake-config.diff
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DEXIV2_BUILD_SAMPLES:BOOL=OFF
        -DEXIV2_ENABLE_NLS:BOOL=${Intl_FOUND}
)
else()
  add_custom_target(exiv2)
endif()
