#!/bin/bash

set -e
set -u

usage() { echo "Usage: $0" 1>&2; echo; exit 1; }
qt_version="qt5"
local_target=true
universal=false
build_cmake=false

while getopts "c:u:s:" o; do
    case "${o}" in
        c)
            if [[ ${OPTARG} == "make" ]]; then
                build_cmake=true
            fi
            ;;
        u)
            if [[ ${OPTARG} == "niversal" ]]; then
                universal=true
            fi
            ;;
        s)
            if [[ ${OPTARG} == "ystem" ]]; then
                local_target=false
            fi
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# Determine platform type
platform="unknown"
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    platform='linux'
elif [[ "$OSTYPE" == "darwin"* ]]; then
    platform='macosx'
fi
if [[ "$platform" == "unknown" ]]; then
    echo "Could not determine platform, exiting"
    exit
fi

jval=4
if [[ "$platform" == "linux" ]]; then
    jval=$(nproc)
elif [[ "$platform" == "macosx" ]]; then
    jval=$(sysctl -n hw.ncpu)
fi

cd `dirname $0`
ENV_ROOT="$PWD"
BUILD_DIR="${ENV_ROOT}/build"
TARGET_DIR="${ENV_ROOT}/deps"
if [[ ${local_target} == false ]]; then
    TARGET_DIR="/usr/local"
fi

CMAKE_PREFIX=""
CONFIGURE_PREFIX=""
BOOST_BOOTSTRAP_CLANG=""
BOOST_B2_CLANG=""
OSX_SDK_VERSION=""
OSX_CMAKE_SDK=""
OSX_BOOST_SDK=""

if [[ ${local_target} == true ]]; then
    CMAKE_PREFIX="-DCMAKE_INSTALL_PREFIX=${TARGET_DIR}"
    CONFIGURE_PREFIX="-prefix ${TARGET_DIR}"
    rm -rf "$TARGET_DIR"
    mkdir -p "$TARGET_DIR"
fi

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

export LDFLAGS="-L${TARGET_DIR}/lib"
export DYLD_LIBRARY_PATH="${TARGET_DIR}/lib"
export PKG_CONFIG_PATH="$TARGET_DIR/lib/pkgconfig"
export CFLAGS="-I${TARGET_DIR}/include $LDFLAGS"
export PATH="${TARGET_DIR}/bin:${PATH}"


echo "#### VC Dependencies ####"
echo "Building universal binaries: $universal"
echo "Building CMake: $build_cmake"
cd $BUILD_DIR

# Target a specific OSX version
if [[ "$platform" == "macosx" ]] && [[ $universal == true ]]; then
    mkdir -p SDKs
    cd SDKs/
    ${ENV_ROOT}/fetchurl "https://7bba5af52f57be309d65f0be55832483b029b4bd.googledrive.com/host/0BxjtEz6no21sSnZtNVItcEFwaTA/MacOSX10.9.sdk.tar.gz"
    cd $BUILD_DIR

    OSX_SDK_VERSION="10.9"
    OSX_CMAKE_SDK="-DCMAKE_OSX_SYSROOT=${BUILD_DIR}/SDKs/MacOSX10.9.sdk/ -DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_SDK_VERSION}"
    OSX_BOOST_SDK="macosx-version=${OSX_SDK_VERSION} macosx-version-min=${OSX_SDK_VERSION}"
fi

${ENV_ROOT}/fetchurl "https://downloads.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz"
${ENV_ROOT}/fetchurl "http://download.osgeo.org/libtiff/tiff-4.0.8.tar.gz"
${ENV_ROOT}/fetchurl "https://downloads.sourceforge.net/project/boost/boost/1.65.1/boost_1_65_1.tar.gz"
${ENV_ROOT}/fetchurl "http://www.vtk.org/files/release/8.0/VTK-8.0.1.tar.gz"
${ENV_ROOT}/fetchurl "https://github.com/valette/ACVD/archive/d5d8c16.tar.gz"
${ENV_ROOT}/fetchurl "https://github.com/opencv/opencv/archive/3.3.1.tar.gz"
${ENV_ROOT}/fetchurl "https://downloads.sourceforge.net/project/itk/itk/4.12/InsightToolkit-4.12.2.tar.gz"
${ENV_ROOT}/fetchurl "https://github.com/bulletphysics/bullet3/archive/2.87.tar.gz"
${ENV_ROOT}/fetchurl "http://bitbucket.org/eigen/eigen/get/3.3.3.tar.gz"
${ENV_ROOT}/fetchurl "https://github.com/mariusmuja/flann/archive/1.9.1.tar.gz"
${ENV_ROOT}/fetchurl "https://github.com/cnr-isti-vclab/vcglib/archive/38ca45f.tar.gz"
${ENV_ROOT}/fetchurl "https://github.com/libigl/libigl/archive/d4b6726.tar.gz"

# Optionally build cmake
if [[ ${build_cmake} == true ]]; then
    ${ENV_ROOT}/fetchurl "https://cmake.org/files/v3.9/cmake-3.9.6.tar.gz"
    echo "*** Building CMake ***"
    cd $BUILD_DIR/cmake*

    ./bootstrap --prefix=${TARGET_DIR} && \
    make -j${jval} install
fi

echo "*** Building zlib ***"
cd $BUILD_DIR/zlib*
mkdir -p build && \
cd build/ && \
cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} ${OSX_CMAKE_SDK} .. && \
make -j${jval} install

echo "*** Building libtiff ***"
cd $BUILD_DIR/tiff*
cmake -Dlzma=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} ${OSX_CMAKE_SDK} . && \
make -j${jval} install

echo "*** Building boost ***"
cd $BUILD_DIR/boost*

# Help boost find the OSX SDK
if [[ "$platform" == "macosx" ]] && [[ ${universal} == true ]]; then
XCODE_ROOT=${BUILD_DIR}/
        cat >> tools/build/src/user-config.jam <<EOF
using darwin : ${OSX_SDK_VERSION}
: g++ -arch x86_64
: <striper> <root>${XCODE_ROOT}
: <target-os>darwin
;
EOF
elif [[ "$platform" == "linux" ]]; then
    BOOST_BOOTSTRAP_CLANG="--with-toolset=clang"
    BOOST_B2_CLANG="toolset=clang"
fi
BOOST_LIBS="atomic,chrono,date_time,exception,iostreams,filesystem,program_options,random,regex,serialization,signals,system,test,thread"
./bootstrap.sh --prefix=${TARGET_DIR} --with-libraries=$BOOST_LIBS ${BOOST_BOOTSTRAP_CLANG} && \
./b2 -j ${jval} cxxflags="-arch x86_64 -std=c++11" variant=release link=static ${BOOST_B2_CLANG} ${OSX_BOOST_SDK} install

echo "*** Building VTK ***"
cd $BUILD_DIR/VTK*
mkdir -p build && \
cd build/ && \
cmake -DBUILD_SHARED_LIBS=OFF -DVTK_USE_SYSTEM_TIFF=ON -DVTK_USE_SYSTEM_ZLIB=ON -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} ${OSX_CMAKE_SDK} .. && \
make -j${jval} install

echo "*** Building ACVD ***"
cd $BUILD_DIR/ACVD*
mkdir -p build && \
cd build/ && \
cmake -DBUILD_EXAMPLES=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} ${OSX_CMAKE_SDK} .. && \
make -j${jval} install

echo "*** Building OpenCV ***"
cd $BUILD_DIR/opencv*
mkdir -p build && \
cd build/ && \
cmake -DWITH_IPP=OFF -DWITH_VTK=OFF -DWITH_CUDA=OFF -DBUILD_TIFF=OFF -DBUILD_ZLIB=OFF -DBUILD_TESTS=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} ${OSX_CMAKE_SDK} .. && \
make -j${jval} install

echo "*** Building ITK ***"
cd $BUILD_DIR/InsightToolkit*
mkdir -p build && \
cd build/ && \
cmake -DITK_USE_SYSTEM_TIFF=ON -DITK_USE_SYSTEM_ZLIB=ON -DModule_ITKVideoBridgeOpenCV=ON -DBUILD_EXAMPLES=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} ${OSX_CMAKE_SDK} .. && \
make -j${jval} install

echo "*** Building Bullet Physics ***"
cd $BUILD_DIR/bullet*
mkdir -p build && \
cd build/ && \
cmake -DBUILD_BULLET2_DEMOS=OFF -DBUILD_CPU_DEMOS=OFF -DBUILD_OPENGL3_DEMOS=OFF -DBUILD_UNIT_TESTS=OFF -DBUILD_SHARED_LIBS=OFF -DBUILD_PYBULLET=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} ${OSX_CMAKE_SDK} .. && \
make -j${jval} install

echo "*** Building Eigen ***"
cd $BUILD_DIR/eigen*
mkdir -p build && \
cd build/ && \
cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} ${OSX_CMAKE_SDK} .. && \
make install

echo "*** Installing VCG Library ***"
cd $BUILD_DIR/vcg*
mkdir -p "${TARGET_DIR}/include/vcg"
cp -R * "${TARGET_DIR}/include/vcg"

echo "*** Installing libigl ***"
cd $BUILD_DIR/libigl*
mkdir -p "${TARGET_DIR}/include/igl"
cp -R include/ "${TARGET_DIR}/include/"

echo "*** Build Complete ***"
