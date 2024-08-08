option(VCDEPS_BUILD_PNG "Build libpng" ON)
if(VCDEPS_BUILD_PNG)
externalproject_add(
    libpng
    DEPENDS zlib ${GLOBAL_DEPENDS}
    URL https://github.com/pnggroup/libpng/archive/e4a31f024b6158aaaf55a43502f574d5f5d1c894.tar.gz
    URL_HASH SHA512=7d068f1ae53f9d080a8043911d93f76b39082a72c4c4c57e924f1a76c73edb504b96ac896bc032f689cc75d3410f1856b740fe817d2507a7ef2cf25ee90f5e04
    DOWNLOAD_NO_PROGRESS true
    DOWNLOAD_EXTRACT_TIMESTAMP ON
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DPNG_TESTS:BOOL=OFF
        -DPNG_TOOLS:BOOL=ON
)
else()
  find_package(PNG REQUIRED)
  add_custom_target(libpng)
endif()
