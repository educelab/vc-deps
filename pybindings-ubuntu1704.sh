#!/bin/bash

# The only things we can get from apt
apt-get update
apt-get install -y ninja-build cmake python3 python3-pip qtbase5-dev \
                build-essential libboost-all-dev libeigen3-dev libflann-dev \
                git curl cmake-curses-gui libxt-dev
pip3 install numpy

# Setup our working directory
mkdir -p ~/source/
cd ~/source/
rm -rf *

# ITK
cd ~/source/
curl -L -O "https://downloads.sourceforge.net/project/itk/itk/4.12/InsightToolkit-4.12.2.tar.gz"
tar -xzf InsightToolkit-4.12.2.tar.gz
cd InsightToolkit*/
mkdir -p build
cd build/
cmake -GNinja .. && \
ninja install

# VTK
cd ~/source/
curl -L -O "http://www.vtk.org/files/release/8.0/VTK-8.0.1.tar.gz"
tar -xzf VTK-8.0.1.tar.gz
cd VTK*/
mkdir -p build
cd build/
cmake -GNinja .. && \
ninja install

# ACVD
cd ~/source/
curl -L -O "https://github.com/valette/ACVD/archive/d5d8c16.tar.gz"
tar -xzf d5d8c16.tar.gz
cd ACVD*/
mkdir -p build
cd build/
cmake -GNinja .. && \
ninja install

# OpenCV
cd ~/source/
curl -L -O "https://github.com/opencv/opencv/archive/3.3.1.tar.gz"
tar -xzf 3.3.1.tar.gz
cd opencv*/
mkdir -p build
cd build/
cmake -GNinja .. && \
ninja install

# pybind11
cd ~/source/
curl -L -O "https://github.com/pybind/pybind11/archive/a303c6f.tar.gz"
tar -xzf a303c6f.tar.gz
cd pybind11*/
mkdir -p build
cd build/
cmake -DPYBIND11_TEST=OFF -GNinja .. && \
ninja install

cd ~/source/
