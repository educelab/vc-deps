option(VCDEPS_BUILD_SPDLOG "Build spdlog" ON)
if(VCDEPS_BUILD_SPDLOG)
externalproject_add(
    spdlog
    DEPENDS ${GLOBAL_DEPENDS}
    URL https://github.com/gabime/spdlog/archive/v1.12.0.tar.gz
    URL_HASH SHA512=db9a4f13b6c39ffde759db99bcdfe5e2dbe4231e73b29eb906a3fa78d6b8ec66920b8bd4371df17ae21b7b562472a236bc4435678f3af92b6496be090074181d
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
