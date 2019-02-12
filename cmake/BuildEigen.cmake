option(VCDEPS_BUILD_EIGEN "Build Eigen" ON)
if(VCDEPS_BUILD_EIGEN)
externalproject_add(
    eigen
    DEPENDS boost ${GLOBAL_DEPENDS}
    URL http://bitbucket.org/eigen/eigen/get/3.3.5.tar.gz
    URL_HASH SHA256=0454b6bacafd2bf641e0fb0f59572b9995728b77e41d1b8517f807334d07e68e
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
)
else()
  find_package(Eigen3 3.2 REQUIRED)
  add_custom_target(eigen)
endif()
