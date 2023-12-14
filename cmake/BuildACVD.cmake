option(VCDEPS_BUILD_ACVD "Build ACVD" ON)
if(VCDEPS_BUILD_ACVD)
externalproject_add(
    acvd
    DEPENDS vtk ${GLOBAL_DEPENDS}
    URL https://gitlab.com/educelab/acvd/-/archive/9efaeb4d18f66d484b52d6088b09b94f0ae97c5c/acvd-9efaeb4d18f66d484b52d6088b09b94f0ae97c5c.tar.gz
    URL_HASH SHA512=9fac34f07df999be8f289c9dbd51310c59f4be14020c861408d0947ac7fb4d0a7c2a8fa97e194298b1ee183231bd2914081d9416ab4b636ea936f8707dd27d94
    DOWNLOAD_NO_PROGRESS true
    DOWNLOAD_EXTRACT_TIMESTAMP ON
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DACVD_BUILD_EXAMPLES:BOOL=OFF
)
else()
  add_custom_target(acvd)
endif()