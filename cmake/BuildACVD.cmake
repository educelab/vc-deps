option(VCDEPS_BUILD_ACVD "Build ACVD" ON)
if(VCDEPS_BUILD_ACVD)
externalproject_add(
    acvd
    DEPENDS vtk ${GLOBAL_DEPENDS}
    URL https://github.com/csparker247/ACVD/archive/v1.1.0.tar.gz
    URL_HASH SHA256=6c9b36f7b595e2ec3763b9f11ac1902f05477ba12a76f0230bd3c886aac7585e
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DBUILD_EXAMPLES:BOOL=OFF
)
else()
  add_custom_target(acvd)
endif()
