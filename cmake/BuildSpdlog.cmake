option(VCDEPS_BUILD_SPDLOG "Build spdlog" ON)
if(VCDEPS_BUILD_SPDLOG)
externalproject_add(
    spdlog
    DEPENDS ${GLOBAL_DEPENDS}
    URL https://github.com/gabime/spdlog/archive/v1.9.2.tar.gz
    URL_HASH SHA512=87b12a792cf2d740ef29db4b6055788a487b6d474662b878711b8a5534efea5f0d97b6ac357834500b66cc65e1ba8934446a695e9691fd5d4b95397b6871555c
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
