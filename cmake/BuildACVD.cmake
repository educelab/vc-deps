option(VCDEPS_BUILD_ACVD "Build ACVD" ON)
if(VCDEPS_BUILD_ACVD)
externalproject_add(
    acvd
    DEPENDS vtk ${GLOBAL_DEPENDS}
    URL https://github.com/csparker247/ACVD/archive/v1.1.1.tar.gz
    URL_HASH SHA256=077dd3fc7a6bd581377d670331a6fb5aefe7bb1cd8b3e65bd2058195dc0069d1
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DBUILD_EXAMPLES:BOOL=OFF
)
else()
  add_custom_target(acvd)
endif()
