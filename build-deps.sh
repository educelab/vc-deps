#!/bin/bash

set -e
set -u

usage() { echo "Usage: $0" 1>&2; echo; exit 1; }
qt_version="qt5"
local_target=true

while getopts "s:" o; do
    case "${o}" in
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
CMAKE_PREFIX=""
CONFIGURE_PREFIX=""

if [[ ${local_target} == true ]]; then
    CMAKE_PREFIX="-DCMAKE_INSTALL_PREFIX=${TARGET_DIR}"
    CONFIGURE_PREFIX="-prefix ${TARGET_DIR}"
fi

rm -rf "$BUILD_DIR" "$TARGET_DIR"
mkdir -p "$BUILD_DIR" "$TARGET_DIR"

# NOTE: this is a fetchurl parameter, nothing to do with the current script
#export TARGET_DIR_DIR="$BUILD_DIR"

export LDFLAGS="-L${TARGET_DIR}/lib"
export DYLD_LIBRARY_PATH="${TARGET_DIR}/lib"
export PKG_CONFIG_PATH="$TARGET_DIR/lib/pkgconfig"
export CFLAGS="-I${TARGET_DIR}/include $LDFLAGS"
export PATH="${TARGET_DIR}/bin:${PATH}"

echo "#### VC Dependencies ####"
cd $BUILD_DIR


${ENV_ROOT}/fetchurl "https://downloads.sourceforge.net/project/boost/boost/1.58.0/boost_1_58_0.tar.bz2"
${ENV_ROOT}/fetchurl "http://www.vtk.org/files/release/6.3/VTK-6.3.0.tar.gz"
${ENV_ROOT}/fetchurl "https://github.com/valette/ACVD/archive/vtk6.tar.gz"
${ENV_ROOT}/fetchurl "http://download.osgeo.org/libtiff/tiff-4.0.6.tar.gz"
${ENV_ROOT}/fetchurl "https://github.com/Itseez/opencv/archive/2.4.12.tar.gz"
${ENV_ROOT}/fetchurl "https://downloads.sourceforge.net/project/itk/itk/4.8/InsightToolkit-4.8.1.tar.gz"
${ENV_ROOT}/fetchurl "https://github.com/bulletphysics/bullet3/archive/2.83.6.tar.gz"
${ENV_ROOT}/fetchurl "http://bitbucket.org/eigen/eigen/get/3.2.6.tar.bz2"
${ENV_ROOT}/fetchurl "https://github.com/mariusmuja/flann/archive/1.8.0-src.tar.gz"
${ENV_ROOT}/fetchurl "https://github.com/PointCloudLibrary/pcl/archive/pcl-1.7.2.tar.gz"

echo "*** Building boost ***"
cd $BUILD_DIR/boost*
./bootstrap.sh --prefix=${TARGET_DIR} && \
./b2 variant=release link=static install -j ${jval}

echo "*** Building VTK ***"
cd $BUILD_DIR/VTK*
mkdir build && \
cd build/ && \
cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} .. && \
make -j${jval} && \
make install

echo "*** Building ACVD ***"
cd $BUILD_DIR/ACVD*
mkdir build && \
cd build/ && \
cmake -DBUILD_EXAMPLES=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} .. && \
make -j${jval} && \
make install

echo "*** Building OpenCV ***"
cd $BUILD_DIR/opencv*
mkdir build && \
cd build/ && \
cmake -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} .. && \
make -j $jval && \
make install

echo "*** Building ITK ***"
cd $BUILD_DIR/InsightToolkit*
mkdir build && \
cd build/ && \
cmake -DBUILD_EXAMPLES=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} .. && \
make -j $jval && \
make install

echo "*** Building Bullet Physics ***"
cd $BUILD_DIR/bullet*
mkdir build && \
cd build/ && \
cmake -DBUILD_BULLET2_DEMOS=OFF -DBUILD_CPU_DEMOS=OFF -DBUILD_OPENGL3_DEMOS=OFF -DBUILD_UNIT_TESTS=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} .. && \
make -j $jval && \
make install

echo "*** Building Eigen ***"
cd $BUILD_DIR/eigen*
mkdir build && \
cd build/ && \
cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} .. && \
make install

echo "*** Building FLANN ***"
cd $BUILD_DIR/flann*
mkdir build && \
cd build/ && \
cmake -DBUILD_MATLAB_BINDINGS=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} .. && \
make -j $jval && \
make install

echo "*** Building PCL ***"
cd $BUILD_DIR/pcl*
mkdir build && \
cd build/ && \
cmake -DWITH_VTK=OFF -DWITH_QT=OFF -DBUILD_visualization=OFF -DPCL_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} .. && \
make -j $jval && \
make install
