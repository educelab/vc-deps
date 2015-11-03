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
../fetchurl "https://download.qt.io/official_releases/qt/5.5/5.5.0/single/qt-everywhere-opensource-src-5.5.0.tar.gz"
../fetchurl "https://github.com/Itseez/opencv/archive/3.0.0.tar.gz"
../fetchurl "http://downloads.sourceforge.net/project/itk/itk/4.8/InsightToolkit-4.8.1.tar.gz?r=http%3A%2F%2Fwww.itk.org%2FITK%2Fresources%2Fsoftware.html&ts=1446500569&use_mirror=iweb"
../fetchurl "https://github.com/bulletphysics/bullet3/archive/2.83.6.tar.gz"
../fetchurl "http://bitbucket.org/eigen/eigen/get/3.2.6.tar.bz2"
../fetchurl "http://www.cs.ubc.ca/research/flann/uploads/FLANN/flann-1.8.4-src.tar.gz"
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

echo "*** Building Qt5 ***"
cd $BUILD_DIR/qt*
./configure -developer-build -opensource -confirm-license -static -nomake examples -nomake tests -prefix ${TARGET_DIR} && \
make -j${jval} && \
make install

# echo "*** Building libpng ***"
# cd $BUILD_DIR/libpng*
# ./configure --prefix=${TARGET_DIR} --enable-static --disable-shared && \
# make -j $jval && \
# make install

# # Ogg before vorbis
# echo "*** Building libogg ***"
# cd $BUILD_DIR/libogg*
# ./configure --prefix=${TARGET_DIR} --enable-static --disable-shared && \
# make -j $jval && \
# make install

# # Vorbis before theora
# echo "*** Building libvorbis ***"
# cd $BUILD_DIR/libvorbis*
# ./configure --prefix=${TARGET_DIR} --with-ogg-libraries=${TARGET_DIR}/lib --with-ogg-includes=${TARGET_DIR}/include/ --enable-static --disable-shared && \
# make -j $jval && \
# make install

# echo "*** Building libtheora ***"
# cd $BUILD_DIR/libtheora*
# perl -p -i -e "s/-falign-loops=16//g" configure
# perl -p -i -e "s/-fforce-addr//g"     configure
# ./configure --prefix=${TARGET_DIR} --with-ogg-libraries=${TARGET_DIR}/lib --with-ogg-includes=${TARGET_DIR}/include/ --with-vorbis-libraries=${TARGET_DIR}/lib --with-vorbis-includes=${TARGET_DIR}/include/ --enable-static --disable-shared && \
# make -j $jval && \
# make install

# echo "*** Building livpx ***"
# cd $BUILD_DIR/libvpx*
# ./configure --prefix=${TARGET_DIR} --disable-unit-tests --disable-shared && \
# make -j $jval && \
# make install

# if [[ $free == "" ]]; then
# 	echo "*** Building fdk-aac ***"
# 	cd "$BUILD_DIR/fdk-aac-0.1.0"
# 	./configure --prefix=${TARGET_DIR} --enable-static --disable-shared && \
# 	make -j 4 && \
# 	make install
# fi

# echo "*** Building x264 ***"
# cd $BUILD_DIR/x264*
# ./configure --prefix=${TARGET_DIR} --enable-static --disable-shared && \
# make -j $jval && \
# make install

# echo "*** Building xvidcore ***"
# cd "$BUILD_DIR/xvidcore/build/generic"
# ./configure --prefix=${TARGET_DIR} --enable-static --disable-shared && \
# make -j $jval && \
# make install
# #rm ${TARGET_DIR}/lib/libxvidcore.so.*

# echo "*** Building lame ***"
# cd $BUILD_DIR/lame*
# ./configure --prefix=${TARGET_DIR} --enable-static --disable-shared && \
# make -j $jval && \
# make install

# echo "*** Building opus ***"
# cd $BUILD_DIR/opus*
# ./configure --prefix=${TARGET_DIR} --enable-static --disable-shared && \
# make -j $jval && \
# make install

# rm -f "${TARGET_DIR}/lib/*.dylib"
# rm -f "${TARGET_DIR}/lib/*.so"

# # FFMpeg
# echo "*** Building FFmpeg ***"
# cd $BUILD_DIR/ffmpeg*
# export LDFLAGS="-L${TARGET_DIR}/lib" 
# export CFLAGS="-I${TARGET_DIR}/include" 
# ./configure --prefix=${TARGET_DIR} --arch=x86_64 --disable-debug --disable-shared --enable-static --enable-runtime-cpudetect --enable-gpl --enable-version3 \
# --disable-ffplay --disable-ffserver --disable-doc  --enable-pthreads --enable-postproc \
# --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libx264 --enable-libxvid --enable-bzlib --enable-zlib --enable-libvpx $freeopts && \
# make -j $jval && \
# make install