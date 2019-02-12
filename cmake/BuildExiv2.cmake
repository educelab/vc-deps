option(VCDEPS_BUILD_EXIV2 "Build exiv2" ON)
if(VCDEPS_BUILD_EXIV2)
find_package(Intl QUIET)
externalproject_add(
    exiv2
    DEPENDS ${GLOBAL_DEPENDS}
    URL https://github.com/Exiv2/exiv2/archive/75e1a03.tar.gz
    URL_HASH SHA256=d6661d4057d67228345a201fa9a9ba70a64bee62d9922472697dfca53a0f2945
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DEXIV2_BUILD_SAMPLES:BOOL=OFF
        -DEXIV2_ENABLE_NLS:BOOL=${Intl_FOUND}
)
else()
  add_custom_target(exiv2)
endif()
