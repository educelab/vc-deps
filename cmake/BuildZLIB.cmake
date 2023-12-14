option(VCDEPS_BUILD_ZLIB "Build zlib" ON)
if(VCDEPS_BUILD_ZLIB)
externalproject_add(
    zlib
    DEPENDS ${GLOBAL_DEPENDS}
    URL https://github.com/madler/zlib/archive/v1.3.tar.gz
    URL_HASH SHA512=78eecf335b14af1f7188c039a4d5297b74464d61156e4f12a485c74beec7d62c4159584ad482a07ec57ae2616d58873e45b09cb8ea822bb5b17e43d163df84e9
    DOWNLOAD_NO_PROGRESS true
    DOWNLOAD_EXTRACT_TIMESTAMP ON
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
)
else()
  find_package(ZLIB REQUIRED)
  add_custom_target(zlib)
endif()
