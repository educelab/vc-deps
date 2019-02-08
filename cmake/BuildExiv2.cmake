option(VCDEPS_BUILD_EXIV2 "Build exiv2" ON)
if(VCDEPS_BUILD_EXIV2)
find_package(Intl QUIET)
externalproject_add(
    exiv2
    DEPENDS ${GLOBAL_DEPENDS}
    URL http://www.exiv2.org/builds/exiv2-0.27.0a-Source.tar.gz
    URL_HASH SHA256=a4adfa7aaf295b0383adead476f8e0493b9d6c6c7570d5884d2ebf8a2871902f
    DOWNLOAD_NO_PROGRESS true
    PATCH_COMMAND patch -p1 -i ${CMAKE_SOURCE_DIR}/patches/exiv2.0.27.0-cmake-libintl.diff
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DEXIV2_BUILD_SAMPLES:BOOL=OFF
        -DEXIV2_ENABLE_NLS:BOOL=${Intl_FOUND}
)
else()
  add_custom_target(exiv2)
endif()
