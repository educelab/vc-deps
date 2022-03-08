option(VCDEPS_BUILD_ACVD "Build ACVD" ON)
if(VCDEPS_BUILD_ACVD)
externalproject_add(
    acvd
    DEPENDS vtk ${GLOBAL_DEPENDS}
    URL https://gitlab.com/educelab/acvd/-/archive/v1.2/acvd-v1.2.tar.gz
    URL_HASH SHA512=9ab02d65e11c014060ee831ad51f342eb0b72c0f0a09e0e496167f42741d0c35e9ac450b49b3eefc2952cb70330883a18c5565f149d80e47931b0844a705da5a
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DACVD_BUILD_EXAMPLES:BOOL=OFF
)
else()
  add_custom_target(acvd)
endif()
