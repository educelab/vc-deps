option(VCDEPS_BUILD_ZLIB "Build zlib" ON)
if(VCDEPS_BUILD_ZLIB)
externalproject_add(
    zlib
    DEPENDS ${GLOBAL_DEPENDS}
    URL https://downloads.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz
    URL_HASH SHA1=e6d119755acdf9104d7ba236b1242696940ed6dd
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
)
else()
  find_package(zlib REQUIRED)
  add_custom_target(zlib)
endif()
