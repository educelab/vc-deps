option(VCDEPS_BUILD_SPDLOG "Build spdlog" ON)
if(VCDEPS_BUILD_SPDLOG)
externalproject_add(
    spdlog
    DEPENDS ${GLOBAL_DEPENDS}
    URL https://github.com/gabime/spdlog/archive/v1.2.1.tar.gz
    URL_HASH SHA256=867a4b7cedf9805e6f76d3ca41889679054f7e5a3b67722fe6d0eae41852a767
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
)
else()
  add_custom_target(spdlog)
endif()
