option(VCDEPS_BUILD_GSL "Build GNU Scientific Library" ON)
if(VCDEPS_BUILD_GSL)

# make sure the prefix is an absolute path
file(REAL_PATH ${CMAKE_INSTALL_PREFIX} GSL_INSTALL_PREFIX EXPAND_TILDE)

if(CMAKE_POSITION_INDEPENDENT_CODE)
    set(GSL_WITH_PIC "--with-pic")
endif()


if(BUILD_MACOS_MULTIARCH)
    set(GSL_CFLAGS "export CFLAGS=\"-arch x86_64 -arch arm64\";")
endif()

externalproject_add(
    gsl
    DEPENDS ${GLOBAL_DEPENDS}
    URL https://ftpmirror.gnu.org/gsl/gsl-2.8.tar.gz
    URL_HASH SHA512=4427f6ce59dc14eabd6d31ef1fcac1849b4d7357faf48873aef642464ddf21cc9b500d516f08b410f02a2daa9a6ff30220f3995584b0a6ae2f73c522d1abb66b
    DOWNLOAD_NO_PROGRESS true
    DOWNLOAD_EXTRACT_TIMESTAMP ON
    PATCH_COMMAND ${GSL_PATCH_CMD}
    CONFIGURE_COMMAND "${GSL_CFLAGS} ./configure --prefix=${GSL_INSTALL_PREFIX} ${GSL_WITH_PIC}"
    BUILD_COMMAND make install
    BUILD_IN_SOURCE true
    INSTALL_COMMAND ""
)

else()
    add_custom_target(gsl)
endif()