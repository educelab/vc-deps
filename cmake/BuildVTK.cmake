option(VCDEPS_BUILD_VTK "Build VTK" ON)
if(VCDEPS_BUILD_VTK)
externalproject_add(
    vtk
    DEPENDS zlib libtiff ${GLOBAL_DEPENDS}
    URL https://www.vtk.org/files/release/8.1/VTK-8.1.0.tar.gz
    URL_HASH MD5=4fa5eadbc8723ba0b8d203f05376d932
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DVTK_USE_SYSTEM_TIFF:BOOL=ON
        -DVTK_USE_SYSTEM_ZLIB:BOOL=ON
)
else()
  # We only support VTK 7 and 8
  find_package(VTK 7 QUIET)
  if(NOT VTK_FOUND)
      find_package(VTK 8 QUIET REQUIRED)
  endif()
  add_custom_target(vtk)
endif()
