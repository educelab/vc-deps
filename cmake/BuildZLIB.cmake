option(VCDEPS_BUILD_ZLIB "Build zlib" ON)
if(VCDEPS_BUILD_ZLIB)
externalproject_add(
    zlib
    DEPENDS ${GLOBAL_DEPENDS}
    URL https://github.com/madler/zlib/archive/v1.2.11.tar.gz
    URL_HASH SHA256=629380c90a77b964d896ed37163f5c3a34f6e6d897311f1df2a7016355c45eff
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
)
else()
  find_package(ZLIB REQUIRED)
  add_custom_target(zlib)
endif()
