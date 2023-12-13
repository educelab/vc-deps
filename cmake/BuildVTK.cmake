option(VCDEPS_BUILD_VTK "Build VTK" ON)
if(VCDEPS_BUILD_VTK)
externalproject_add(
    vtk
    DEPENDS zlib libtiff ${GLOBAL_DEPENDS}
    URL https://www.vtk.org/files/release/9.3/VTK-9.3.0.tar.gz
    URL_HASH SHA256=fdc7b9295225b34e4fdddc49cd06e66e94260cb00efee456e0f66568c9681be9
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
