Volume Cartographer Dependency Builder
======================================

CMake project to build Volume Cartographer dependencies.

Requirements
------------
 * Clang 3.4+ (Boost only)
 * C++ build system (e.g. Make or Ninja)
 * CMake 3.9+

Get The Source
--------------
```shell
git clone git@code.cs.uky.edu:seales-research/vc-deps.git
cd vc-deps/
```

Installation
------------
```shell
mkdir -p build/
cd build/
cmake ..
make
```
By default, dependencies will be installed into the `vc-deps/deps/` subdirectory. To install to a different location, 
set the `CMAKE_INSTALL_PREFIX` CMake flag to your desired installation prefix.

Optional Arguments
------------------
Optionally, you can create Release/Debug builds and static/shared libraries by providing the corresponding CMake arguments:

```shell
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON ..
```