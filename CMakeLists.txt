cmake_minimum_required(VERSION 3.9 FATAL_ERROR)

project(vc-deps VERSION 1.2.0)

include(ExternalProject)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#### Options ####
option(BUILD_SHARED_LIBS "Build libraries as shared" OFF)
if(APPLE)
    option(BUILD_UNIVERSAL_LIBS "Build universal macOS libraries using an SDK" OFF)
endif()
if(BUILD_UNIVERSAL_LIBS)
    set(CMAKE_OSX_DEPLOYMENT_TARGET 10.9 CACHE STRING "Universal macOS SDK Version" FORCE )
endif()

#### Setup output directory if not specified ####
if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/deps" CACHE PATH "Default Install Path" FORCE )
endif()

#### Global CMake arguments ####
set(GLOBAL_CMAKE_ARGS
    "-DBUILD_SHARED_LIBS:STRING=${BUILD_SHARED_LIBS}"
    "-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}"
    "-DCMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH}"
    "-DCMAKE_CXX_STANDARD:STRING=${CMAKE_CXX_STANDARD}"
    "-DCMAKE_CXX_STANDARD_REQUIRED:BOOL=${CMAKE_CXX_STANDARD_REQUIRED}"
)
set(GLOBAL_DEPENDS "")

#### Build dependencies with same release type as root project ####
if(CMAKE_BUILD_TYPE)
  list(APPEND GLOBAL_CMAKE_ARGS
    "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}"
  )
endif()

# Set Boost build type to match provided release type
if(CMAKE_BUILD_TYPE MATCHES DEBUG)
    set(BOOST_LIB_TYPE debug)
else()
    set(BOOST_LIB_TYPE release)
endif()

# Set Boost link type to match provided link type
if(BUILD_SHARED_LIBS)
    set(BOOST_LINK_TYPE shared)
else()
    set(BOOST_LINK_TYPE static)
endif()

# Set Boost toolset type based on the OS
if(APPLE)
    set(BOOST_TOOLSET_AUTO darwin)
elseif(UNIX AND NOT APPLE)
    set(BOOST_TOOLSET_AUTO clang)
elseif(WIN32)
    set(BOOST_TOOLSET_AUTO msvc)
else()
    set(BOOST_TOOLSET_AUTO gcc)
endif()
set(BOOST_TOOLSET ${BOOST_TOOLSET_AUTO} CACHE STRING "Boost Build toolset")

#### Setup a legacy macOS build using an SDK ####
if (BUILD_UNIVERSAL_LIBS)
    # SDK Dependency
    set(MACOS_SDK_BASENAME MacOSX${CMAKE_OSX_DEPLOYMENT_TARGET}.sdk)
    externalproject_add(
        osx-sdk
        URL https://github.com/phracker/MacOSX-SDKs/releases/download/10.13/${MACOS_SDK_BASENAME}.tar.xz
        URL_HASH SHA1=f35ad1305939fcf14bb1fac036efb2b0c31ebd12
        DOWNLOAD_NO_PROGRESS true
        CONFIGURE_COMMAND mkdir -p SDKs/${MACOS_SDK_BASENAME}
        BUILD_COMMAND mv System SDKs/${MACOS_SDK_BASENAME}/ &&
            mv usr SDKs/${MACOS_SDK_BASENAME}/ &&
            mv SDKSettings.plist SDKs/${MACOS_SDK_BASENAME}/
        INSTALL_COMMAND ""
        BUILD_IN_SOURCE true
    )
    list(APPEND GLOBAL_DEPENDS osx-sdk)

    # Get the SDK sysroot
    ExternalProject_Get_property(osx-sdk SOURCE_DIR)
    set(OSX_SDK_SYSROOT ${SOURCE_DIR})

    # Append the new CMake args
    list(APPEND GLOBAL_CMAKE_ARGS
        -DCMAKE_OSX_SYSROOT:PATH=${OSX_SDK_SYSROOT}/SDKs/${MACOS_SDK_BASENAME}/
        -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET}
    )

    # Setup the Boost arguments and files
    set(BOOST_OSX_SDK macosx-version=${CMAKE_OSX_DEPLOYMENT_TARGET} macosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET})
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/patches/boost-macOS-user-config.jam.in ${CMAKE_CURRENT_BINARY_DIR}/user-config.jam)
    set(BOOST_PATCH_CMD cp ${CMAKE_CURRENT_BINARY_DIR}/user-config.jam tools/build/src/)

endif(BUILD_UNIVERSAL_LIBS)

# zlib
externalproject_add(
    zlib
    DEPENDS ${GLOBAL_DEPENDS}
    URL https://downloads.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz
    URL_HASH SHA1=e6d119755acdf9104d7ba236b1242696940ed6dd
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
)

# libtiff
externalproject_add(
    libtiff
    DEPENDS zlib ${GLOBAL_DEPENDS}
    URL http://download.osgeo.org/libtiff/tiff-4.0.9.tar.gz
    URL_HASH SHA1=87d4543579176cc568668617c22baceccd568296
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -Dlzma:BOOL=OFF
)

# exiv2
externalproject_add(
    exiv2
    DEPENDS ${GLOBAL_DEPENDS}
    URL http://www.exiv2.org/builds/exiv2-0.27.0a-Source.tar.gz
    URL_HASH SHA256=a4adfa7aaf295b0383adead476f8e0493b9d6c6c7570d5884d2ebf8a2871902f
    DOWNLOAD_NO_PROGRESS true
    PATCH_COMMAND patch -p1 -i ${CMAKE_SOURCE_DIR}/patches/exiv2.0.27.0-cmake-libintl.diff
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DEXIV2_BUILD_SAMPLES:BOOL=OFF
)

# spdlog
externalproject_add(
    spdlog
    DEPENDS ${GLOBAL_DEPENDS}
    URL https://github.com/gabime/spdlog/archive/v1.2.1.tar.gz
    URL_HASH SHA256=867a4b7cedf9805e6f76d3ca41889679054f7e5a3b67722fe6d0eae41852a767
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
)

# VCG library
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

# Boost
set(BOOST_BUILD_LIBS "atomic,chrono,date_time,exception,iostreams,filesystem,program_options,random,regex,serialization,signals,system,test,thread")
externalproject_add(
    boost
    DEPENDS ${GLOBAL_DEPENDS}
    URL https://downloads.sourceforge.net/project/boost/boost/1.65.1/boost_1_65_1.tar.gz
    URL_HASH SHA1=c066ac5c2f42fa2b870362c3c931ef73ffc6f24f
    DOWNLOAD_NO_PROGRESS true
    PATCH_COMMAND ${BOOST_PATCH_CMD}
    CONFIGURE_COMMAND ./bootstrap.sh --prefix=${CMAKE_INSTALL_PREFIX} --with-libraries=${BOOST_BUILD_LIBS} --with-toolset=${BOOST_TOOLSET}
    BUILD_COMMAND ./b2 cxxflags="-std=c++${CMAKE_CXX_STANDARD}" variant=${BOOST_LIB_TYPE} link=${BOOST_LINK_TYPE} toolset=${BOOST_TOOLSET} ${BOOST_OSX_SDK} install
    BUILD_IN_SOURCE true
    INSTALL_COMMAND ""
)

# Eigen
externalproject_add(
    eigen
    DEPENDS boost ${GLOBAL_DEPENDS}
    URL http://bitbucket.org/eigen/eigen/get/3.3.5.tar.gz
    URL_HASH SHA256=0454b6bacafd2bf641e0fb0f59572b9995728b77e41d1b8517f807334d07e68e
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
)

# VTK
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

# ACVD
externalproject_add(
    acvd
    DEPENDS vtk ${GLOBAL_DEPENDS}
    URL https://github.com/valette/ACVD/archive/d5d8c16.tar.gz
    URL_HASH SHA1=c9655ff995058f31af37479cde08ae5dfedeecee
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DBUILD_EXAMPLES:BOOL=OFF
        -DCMAKE_BUILD_TYPE:STRING=Release
)

# OpenCV
externalproject_add(
    opencv
    DEPENDS eigen zlib libtiff ${GLOBAL_DEPENDS}
    URL https://github.com/opencv/opencv/archive/3.3.1.tar.gz
    URL_HASH SHA1=79dba99090a5c48308fe91db8336ec2931e06b57
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DWITH_VTK:BOOL=OFF
        -DWITH_CUDA:BOOL=OFF
        -DBUILD_TIFF:BOOL=OFF
        -DBUILD_ZLIB:BOOL=OFF
        -DBUILD_TESTS:BOOL=OFF
        -DWITH_FFMPEG:BOOL=OFF
)

# ITK
externalproject_add(
    itk
    DEPENDS zlib libtiff opencv ${GLOBAL_DEPENDS}
    URL https://downloads.sourceforge.net/project/itk/itk/4.12/InsightToolkit-4.12.2.tar.gz
    URL_HASH SHA1=8733dab485b2df860bc5808f7f2351773b293feb
    DOWNLOAD_NO_PROGRESS true
    CMAKE_CACHE_ARGS
        ${GLOBAL_CMAKE_ARGS}
        -DITK_USE_SYSTEM_TIFF:BOOL=ON
        -DITK_USE_SYSTEM_ZLIB:BOOL=ON
        -DModule_ITKVideoBridgeOpenCV:BOOL=ON
        -DBUILD_EXAMPLES:BOOL=OFF
)
