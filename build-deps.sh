#!/bin/sh

set -e
set -u

usage() { echo "Usage: $0" 1>&2; echo; exit 1; }

while getopts "f" o; do
    case "${o}" in
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

jval=8

cd `dirname $0`
ENV_ROOT="$PWD"
BUILD_DIR="${ENV_ROOT}/build"
TARGET_DIR="${ENV_ROOT}/target"

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
../fetchurl "http://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fboost%2Ffiles%2Fboost%2F1.59.0%2F&ts=1446500152&use_mirror=skylineservers"
../fetchurl "http://www.vtk.org/files/release/6.3/VTK-6.3.0.tar.gz"
../fetchurl "https://github.com/valette/ACVD/archive/vtk6.tar.gz"
../fetchurl "https://download.qt.io/official_releases/qt/5.5/5.5.1/single/qt-everywhere-opensource-src-5.5.1.tar.gz"
../fetchurl "https://github.com/Itseez/opencv/archive/3.0.0.tar.gz"
../fetchurl "http://downloads.sourceforge.net/project/itk/itk/4.8/InsightToolkit-4.8.1.tar.gz?r=http%3A%2F%2Fwww.itk.org%2FITK%2Fresources%2Fsoftware.html&ts=1446500569&use_mirror=iweb"
../fetchurl "https://github.com/bulletphysics/bullet3/archive/2.83.6.tar.gz"
../fetchurl "http://bitbucket.org/eigen/eigen/get/3.2.6.tar.bz2"
../fetchurl "https://github.com/mariusmuja/flann/archive/1.8.0-src.tar.gz"
../fetchurl "https://github.com/PointCloudLibrary/pcl/archive/pcl-1.7.2.tar.gz"

echo "*** Building boost ***"
cd $BUILD_DIR/boost*
./bootstrap.sh --prefix=${TARGET_DIR} && \
./b2 variant=release link=static install

echo "*** Building VTK ***"
cd $BUILD_DIR/VTK*
mkdir build && \
cd build/ && \
cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} .. && \
make -j${jval} && \
make install

echo "*** Building ACVD ***"
cd $BUILD_DIR/ACVD*
mkdir build && \
cd build/ && \
cmake -DBUILD_EXAMPLES=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} .. && \
make -j${jval} && \
make install

echo "*** Building Qt5 ***"
cd $BUILD_DIR/qt*
./configure -developer-build -opensource -skip qtWebKit -confirm-license -static -system-zlib -securetransport -qt-libpng -qt-libjpeg -no-rpath -no-openssl -release -nomake examples -nomake tests -prefix ${TARGET_DIR} && \
make -j${jval} && \
make install

echo "*** Building OpenCV ***"
cd $BUILD_DIR/opencv*
mkdir build && \
cd build/ && \
cmake -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} .. && \
make -j $jval && \
make install

echo "*** Building ITK ***"
cd $BUILD_DIR/InsightToolkit*
mkdir build && \
cd build/ && \
cmake -DBUILD_EXAMPLES=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} .. && \
make -j $jval && \
make install

echo "*** Building Bullet Physics ***"
cd $BUILD_DIR/bullet*
mkdir build && \
cd build/ && \
cmake -DBUILD_BULLET2_DEMOS=OFF -DBUILD_CPU_DEMOS=OFF -DBUILD_OPENGL3_DEMOS=OFF -DBUILD_UNIT_TESTS=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} .. && \
make -j $jval && \
make install

echo "*** Building Eigen ***"
cd $BUILD_DIR/eigen*
mkdir build && \
cd build/ && \
cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} .. && \
make install

echo "*** Building FLANN ***"
cd $BUILD_DIR/flann*
mkdir build && \
cd build/ && \
cmake -DBUILD_MATLAB_BINDINGS=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} .. && \
make -j $jval && \
make install

echo "*** Building PCL ***"
cd $BUILD_DIR/pcl*
mkdir build && \
cd build/ && \
cmake -DWITH_VTK=OFF -DWITH_QT=OFF -DBUILD_visualization=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${TARGET_DIR} .. && \
make -j $jval && \
make install