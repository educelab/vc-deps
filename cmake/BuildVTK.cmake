option(VCDEPS_BUILD_VTK "Build VTK" ON)
if(VCDEPS_BUILD_VTK)
externalproject_add(
    vtk
    DEPENDS zlib libtiff ${GLOBAL_DEPENDS}
    URL https://www.vtk.org/files/release/9.3/VTK-9.3.1.tar.gz
    URL_HASH SHA256=8354ec084ea0d2dc3d23dbe4243823c4bfc270382d0ce8d658939fd50061cab8
    DOWNLOAD_NO_PROGRESS true
    DOWNLOAD_EXTRACT_TIMESTAMP ON
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
