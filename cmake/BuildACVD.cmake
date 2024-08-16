option(VCDEPS_BUILD_ACVD "Build ACVD" ON)
if(VCDEPS_BUILD_ACVD)
externalproject_add(
    acvd
    DEPENDS vtk ${GLOBAL_DEPENDS}
    URL https://gitlab.com/educelab/acvd/-/archive/v1.2.1/acvd-v1.2.1.tar.gz
    URL_HASH SHA512=1131ee6deb333cca66667e705d9eed6997e851a5f4c65094e521dd41cccbcd5711405dd2a1c8becf3aaccb852dca94cf020afbe287351b29f7afb652accb6992
    DOWNLOAD_NO_PROGRESS true
    DOWNLOAD_EXTRACT_TIMESTAMP ON
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DACVD_BUILD_EXAMPLES:BOOL=OFF
)
else()
  add_custom_target(acvd)
endif()