option(VCDEPS_BUILD_EIGEN "Build Eigen" ON)
if(VCDEPS_BUILD_EIGEN)
externalproject_add(
    eigen
    DEPENDS boost ${GLOBAL_DEPENDS}
    URL http://bitbucket.org/eigen/eigen/get/3.3.7.tar.gz
    URL_HASH SHA256=7e84ef87a07702b54ab3306e77cea474f56a40afa1c0ab245bb11725d006d0da
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
)
else()
  find_package(Eigen3 3.2 REQUIRED)
  add_custom_target(eigen)
endif()
