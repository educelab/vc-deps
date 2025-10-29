option(VCDEPS_BUILD_VTK "Build VTK" ON)
if(VCDEPS_BUILD_VTK)
externalproject_add(
    vtk
    DEPENDS zlib libtiff ${GLOBAL_DEPENDS}
    URL https://vtk.org/files/release/9.5/VTK-9.5.2.tar.gz
    URL_HASH SHA512=fc8157a89fa603a7f7fce356e2f638ae69e0ea629a507458bdbb173daf511c61e39a1f0d7201b196a5b3a7ffa7e3e821398b62521faadf85edb1119a1e8b8e8e
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
