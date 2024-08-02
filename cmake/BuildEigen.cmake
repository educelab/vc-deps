option(VCDEPS_BUILD_EIGEN "Build Eigen" ON)
if(VCDEPS_BUILD_EIGEN)
externalproject_add(
    eigen
    DEPENDS boost ${GLOBAL_DEPENDS}
    URL https://gitlab.com/libeigen/eigen/-/archive/c593e9e948e5c10234afbac7f6d143ecd9f0c680/eigen-c593e9e948e5c10234afbac7f6d143ecd9f0c680.tar.gz
    URL_HASH SHA512=e1033869457844861f7bb134f503e2cec4c945843c840b913f7be9ec73cb8d261592d953be9b5199a2d6528ad4eed2dbf3b353bc91cebb5159524192edd7f80c
    DOWNLOAD_NO_PROGRESS true
    DOWNLOAD_EXTRACT_TIMESTAMP ON
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
)
else()
  find_package(Eigen3 3.2 REQUIRED)
  add_custom_target(eigen)
endif()
