option(VCDEPS_BUILD_ACVD "Build ACVD" ON)
if(VCDEPS_BUILD_ACVD)
externalproject_add(
    acvd
    DEPENDS vtk ${GLOBAL_DEPENDS}
    URL https://gitlab.com/educelab/acvd/-/archive/v1.1.4/acvd-v1.1.4.tar.gz
    URL_HASH SHA512=76d3f474ccb75bb39a9b9a289c82c9c35d3037fce13b13b05be9a0775b056940152b4bd2fdad910a5330d5687ca979d229c515990b1bac4d6fede7b717db9c8b
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DACVD_BUILD_EXAMPLES:BOOL=OFF
)
else()
  add_custom_target(acvd)
endif()
