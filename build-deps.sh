#!/bin/bash

set -e
set -u

usage() { echo "Usage: $0" 1>&2; echo; exit 1; }
qt_version="qt5"
local_target=true
universal=false

while getopts "u:s:" o; do
    case "${o}" in
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
echo "Building universal binaries: $universal"
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

${ENV_ROOT}/fetchurl "https://downloads.sourceforge.net/project/boost/boost/1.58.0/boost_1_58_0.tar.gz"
${ENV_ROOT}/fetchurl "http://www.vtk.org/files/release/6.3/VTK-6.3.0.tar.gz"
${ENV_ROOT}/fetchurl "https://github.com/valette/ACVD/archive/vtk6.tar.gz"
${ENV_ROOT}/fetchurl "https://github.com/Itseez/opencv/archive/2.4.12.tar.gz"
${ENV_ROOT}/fetchurl "https://downloads.sourceforge.net/project/itk/itk/4.8/InsightToolkit-4.8.1.tar.gz"
${ENV_ROOT}/fetchurl "https://github.com/bulletphysics/bullet3/archive/2.83.6.tar.gz"
${ENV_ROOT}/fetchurl "http://bitbucket.org/eigen/eigen/get/3.2.6.tar.bz2"
${ENV_ROOT}/fetchurl "https://github.com/mariusmuja/flann/archive/1.8.0-src.tar.gz"
if [[ "$platform" == "linux" ]]; then
    ${ENV_ROOT}/fetchurl "https://github.com/PointCloudLibrary/pcl/archive/pcl-1.8.0rc2.tar.gz"
else
    ${ENV_ROOT}/fetchurl "https://github.com/PointCloudLibrary/pcl/archive/pcl-1.7.2.tar.gz"
fi

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
BOOST_LIBS="atomic,chrono,date_time,exception,iostreams,filesystem,program_options,random,serialization,signals,system,test,thread"
./bootstrap.sh --prefix=${TARGET_DIR} --with-libraries=$BOOST_LIBS ${BOOST_BOOTSTRAP_CLANG} && \
./b2 -j ${jval} cxxflags="-arch x86_64 -std=c++11" variant=release link=static ${BOOST_B2_CLANG} ${OSX_BOOST_SDK} install

echo "*** Building VTK ***"
cd $BUILD_DIR/VTK*
mkdir -p build && \
cd build/ && \
cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} ${OSX_CMAKE_SDK} .. && \
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
cmake -DBUILD_TESTS=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} ${OSX_CMAKE_SDK} .. && \
make -j${jval} install

echo "*** Building ITK ***"
cd $BUILD_DIR/InsightToolkit*
mkdir -p build && \
cd build/ && \
cmake -DBUILD_EXAMPLES=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} ${OSX_CMAKE_SDK} .. && \
make -j${jval} install

echo "*** Building Bullet Physics ***"
cd $BUILD_DIR/bullet*
mkdir -p build && \
cd build/ && \
cmake -DBUILD_BULLET2_DEMOS=OFF -DBUILD_CPU_DEMOS=OFF -DBUILD_OPENGL3_DEMOS=OFF -DBUILD_UNIT_TESTS=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} ${OSX_CMAKE_SDK} .. && \
make -j${jval} install

echo "*** Building Eigen ***"
cd $BUILD_DIR/eigen*
mkdir -p build && \
cd build/ && \
cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} ${OSX_CMAKE_SDK} .. && \
make install

echo "*** Building FLANN ***"
cd $BUILD_DIR/flann*
mkdir -p build && \
cd build/ && \
cmake -DBUILD_MATLAB_BINDINGS=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} ${OSX_CMAKE_SDK} .. && \
make -j${jval} install

echo "*** Building PCL ***"
cd $BUILD_DIR/pcl*
mkdir -p build && \
cd build/ && \
cmake -DWITH_VTK=OFF -DWITH_QT=OFF -DBUILD_visualization=OFF -DBUILD_tools=OFF -DPCL_SHARED_LIBS=OFF -DWITH_OPENGL=OFF -DCMAKE_BUILD_TYPE=Release ${CMAKE_PREFIX} ${OSX_CMAKE_SDK} .. && \
make -j${jval} install