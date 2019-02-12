option(VCDEPS_BUILD_ACVD "Build ACVD" ON)
if(VCDEPS_BUILD_ACVD)
externalproject_add(
    acvd
    DEPENDS vtk ${GLOBAL_DEPENDS}
    URL https://github.com/valette/ACVD/archive/d5d8c16.tar.gz
    URL_HASH SHA1=c9655ff995058f31af37479cde08ae5dfedeecee
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DBUILD_EXAMPLES:BOOL=OFF
        -DCMAKE_BUILD_TYPE:STRING=Release
)
else()
  add_custom_target(acvd)
endif()
