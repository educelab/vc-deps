Volume Cartographer Dependency Builder
======================================

CMake project to build Volume Cartographer dependencies.

Requirements
------------
 * C++14 compiler (GCC 5+, Clang 3.4+)
 * CMake 3.9+

Get The Source
--------------
```shell
git clone https://gitlab.com/educelab/vc-deps.git
cd vc-deps/
```

Installation
------------
```shell
mkdir -p build/
cd build/
cmake ..
make -j
```
By default, dependencies will be installed into the `vc-deps/deps/` subdirectory. To install to a different location,
set the `CMAKE_INSTALL_PREFIX` CMake flag to your desired installation prefix.

Enable/Disable Libraries
------------------------
Building a particular dependency can be controlled with the `VCDEPS_BUILD_*` flags. For example, configuring CMake with the following flag will disable the `vc-deps` build of ITK:

```shell
cmake -DVCDEPS_BUILD_ITK=OFF ..
```

Note that certain libraries provided by this package are prerequisites to building other libraries in `vc-deps` (e.g. libtiff is needed to build ITK from source). If one of these prerequisite libraries is disabled, `vc-deps` will check the system path for an already installed replacement. If a compatible library is not found, the build will fail.

To see a full list of available build options, use `ccmake` or run:

```shell
cmake -L ..
```

Build Types and Static or Shared Libraries
------------------------------------------
Optionally, you can create Release/Debug builds and static/shared libraries by providing the corresponding CMake arguments:

```shell
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON ..
```

Position Independent Code
-------------------------
To build libraries with position independent code (PIC), set the `CMAKE_POSITION_INDEPENDENT_CODE` flag:

```shell
cmake -DCMAKE_POSITION_INDEPENDENT_CODE=ON ..
```

PIC is `ON` by default when building shared libraries, so this flag will only affect static builds. This flag must be enabled to successfully link Volume Cartographer's Python bindings against statically built dependencies.
