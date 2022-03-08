option(VCDEPS_BUILD_VTK "Build VTK" ON)
if(VCDEPS_BUILD_VTK)
externalproject_add(
    vtk
    DEPENDS zlib libtiff ${GLOBAL_DEPENDS}
    URL https://www.vtk.org/files/release/9.1/VTK-9.1.0.tar.gz
    URL_HASH SHA256=8fed42f4f8f1eb8083107b68eaa9ad71da07110161a3116ad807f43e5ca5ce96
    DOWNLOAD_NO_PROGRESS true
    PATCH_COMMAND ${VTK_PATCH_CMD}
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DVTK_USE_SYSTEM_TIFF:BOOL=ON
        -DVTK_USE_SYSTEM_ZLIB:BOOL=ON
)
else()
  find_package(VTK 9 QUIET REQUIRED)
  add_custom_target(vtk)
endif()
