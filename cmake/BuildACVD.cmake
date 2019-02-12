option(VCDEPS_BUILD_ACVD "Build ACVD" ON)
if(VCDEPS_BUILD_ACVD)
externalproject_add(
    acvd
    DEPENDS vtk ${GLOBAL_DEPENDS}
    URL https://github.com/csparker247/ACVD/archive/v1.0.1.tar.gz
    URL_HASH SHA256=eb6ef33a56f8086f208bf39ebc85f5f970c24d48fb6a304e94bc08f6c2c1eaf3
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DBUILD_EXAMPLES:BOOL=OFF
)
else()
  add_custom_target(acvd)
endif()
