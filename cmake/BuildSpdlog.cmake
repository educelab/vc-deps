option(VCDEPS_BUILD_SPDLOG "Build spdlog" ON)
if(VCDEPS_BUILD_SPDLOG)
externalproject_add(
    spdlog
    DEPENDS ${GLOBAL_DEPENDS}
    URL https://github.com/gabime/spdlog/archive/v1.16.0.tar.gz
    URL_HASH SHA512=3c330162201fb405a08040327e08bc3f90336f431b8865d250e1cf171e48eb8a07a0245a8f60118022869de1ee38209b14da76bf6bcc2ec3da60f1853adaf958
    DOWNLOAD_NO_PROGRESS true
    DOWNLOAD_EXTRACT_TIMESTAMP ON
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DSPDLOG_BUILD_SHARED:BOOL=${BUILD_SHARED_LIBS}
)
else()
  find_package(spdlog 1.4.2 CONFIG REQUIRED)
  add_custom_target(spdlog)
endif()
