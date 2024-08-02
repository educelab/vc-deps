option(VCDEPS_BUILD_ZLIB "Build zlib" ON)
if(VCDEPS_BUILD_ZLIB)
externalproject_add(
    zlib
    DEPENDS ${GLOBAL_DEPENDS}
    URL https://github.com/madler/zlib/archive/v1.3.1.tar.gz
    URL_HASH SHA512=8c9642495bafd6fad4ab9fb67f09b268c69ff9af0f4f20cf15dfc18852ff1f312bd8ca41de761b3f8d8e90e77d79f2ccacd3d4c5b19e475ecf09d021fdfe9088
    DOWNLOAD_NO_PROGRESS true
    DOWNLOAD_EXTRACT_TIMESTAMP ON
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
)
else()
  find_package(ZLIB REQUIRED)
  add_custom_target(zlib)
endif()
