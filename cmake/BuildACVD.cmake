option(VCDEPS_BUILD_ACVD "Build ACVD" ON)
if(VCDEPS_BUILD_ACVD)
externalproject_add(
    acvd
    DEPENDS vtk ${GLOBAL_DEPENDS}
    URL https://github.com/csparker247/ACVD/archive/v1.1.1.tar.gz
    URL_HASH SHA256=04602959738353ad3139032a3a084a30a321b90a830cb2c2981c66b87a461cfb
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DBUILD_EXAMPLES:BOOL=OFF
)
else()
  add_custom_target(acvd)
endif()
