option(VCDEPS_BUILD_VTK "Build VTK" ON)
if(VCDEPS_BUILD_VTK)

# Patch if Qt 5.15
if(Qt5_VERSION VERSION_GREATER_EQUAL 5.15)
  set(VTK_PATCH_CMD patch -p1 -i ${CMAKE_SOURCE_DIR}/patches/vtk-8.2.0-fix-qt5.15.diff)
endif()

externalproject_add(
    vtk
    DEPENDS zlib libtiff ${GLOBAL_DEPENDS}
    URL https://www.vtk.org/files/release/8.2/VTK-8.2.0.tar.gz
    URL_HASH SHA256=34c3dc775261be5e45a8049155f7228b6bd668106c72a3c435d95730d17d57bb
    DOWNLOAD_NO_PROGRESS true
    PATCH_COMMAND ${VTK_PATCH_CMD}
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DVTK_USE_SYSTEM_TIFF:BOOL=ON
        -DVTK_USE_SYSTEM_ZLIB:BOOL=ON
        -DVTK_Group_Qt:BOOL=${BUILD_WITH_QT5}
)
else()
  # We only support VTK 7 and 8
  find_package(VTK 7 QUIET)
  if(NOT VTK_FOUND)
      find_package(VTK 8 QUIET REQUIRED)
  endif()
  add_custom_target(vtk)
endif()
