option(VCDEPS_BUILD_VCG "Build VCG" ON)
if(VCDEPS_BUILD_VCG)
externalproject_add(
    vcglib
    URL https://github.com/cnr-isti-vclab/vcglib/archive/38ca45f.tar.gz
    URL_HASH SHA1=e1945ce59fb6a187b923844ba1a1a823f416afa8
    DOWNLOAD_NO_PROGRESS true
    BUILD_IN_SOURCE true
    CONFIGURE_COMMAND mkdir -p ${CMAKE_INSTALL_PREFIX}/include/vcg
    BUILD_COMMAND ""
    INSTALL_COMMAND cp -R . ${CMAKE_INSTALL_PREFIX}/include/vcg
)
else()
  add_custom_target(vcglib)
endif()
