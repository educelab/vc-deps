option(VCDEPS_BUILD_VCG "Build VCG" ON)
if(VCDEPS_BUILD_VCG)
externalproject_add(
    vcglib
    URL https://github.com/cnr-isti-vclab/vcglib/archive/9fe918c.tar.gz
    URL_HASH SHA256=61960afd876c145458e19483c7741c929c751027062c08244a9c9df7782ea7cf
    DOWNLOAD_NO_PROGRESS true
    BUILD_IN_SOURCE true
    CONFIGURE_COMMAND mkdir -p ${CMAKE_INSTALL_PREFIX}/include/vcg
    BUILD_COMMAND ""
    INSTALL_COMMAND cp -R . ${CMAKE_INSTALL_PREFIX}/include/vcg
)
else()
  add_custom_target(vcglib)
endif()
