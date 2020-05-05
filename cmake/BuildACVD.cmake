option(VCDEPS_BUILD_ACVD "Build ACVD" ON)
if(VCDEPS_BUILD_ACVD)
externalproject_add(
    acvd
    DEPENDS vtk ${GLOBAL_DEPENDS}
    URL https://github.com/csparker247/ACVD/archive/v1.1.2.tar.gz
    URL_HASH SHA256=4742b7007b9b8ac39103e53e8013bcdb4e2ad1467acf94016dcf85387b93a34b
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DBUILD_EXAMPLES:BOOL=OFF
)
else()
  add_custom_target(acvd)
endif()
