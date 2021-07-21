option(VCDEPS_BUILD_SPDLOG "Build spdlog" ON)
if(VCDEPS_BUILD_SPDLOG)
externalproject_add(
    spdlog
    DEPENDS ${GLOBAL_DEPENDS}
    URL https://github.com/gabime/spdlog/archive/v1.8.5.tar.gz
    URL_HASH SHA512=77cc9df0c40bbdbfe1f3e5818dccf121918bfceac28f2608f39e5bf944968b7e8e24a6fc29f01bc58a9bae41b8892d49cfb59c196935ec9868884320b50f130c
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DSPDLOG_BUILD_SHARED:BOOL=${BUILD_SHARED_LIBS}
)
else()
  find_package(spdlog 1.4.2 CONFIG REQUIRED)
  add_custom_target(spdlog)
endif()
