Volume Cartographer Dependency Builder
======================================

CMake project to build Volume Cartographer dependencies.

Requirements
------------
 * Clang 3.4+ (Boost only)
 * C++ build system (e.g. Make or Ninja)
 * CMake 3.9+

Usage
-----
```shell
git clone git@code.vis.uky.edu:seales-research/vc-deps.git  
cd vc-deps/  
mkdir -p build/
cd build/
cmake [ -DCMAKE_BUILD_TYPE=Release ] [ -DBUILD_SHARED_LIBS=ON ] [ -DCMAKE_INSTALL_PREFIX=/usr/local/ ] ..
make
```