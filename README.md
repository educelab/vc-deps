Volume Cartographer Dependency Builder
======================================

Script to build static versions of Volume Cartographer dependencies.  

Requirements
------------
 * C++ Build System and GNU Make tools
 * pkg-config
 * cmake
 * XCode (Required if building Qt5 on OSX)

Usage
-----
```bash
git clone git@code.vis.uky.edu:seales-research/vc-deps.git  
cd vc-deps/  
./build-deps.sh  
```